
#encoding:utf-8
class SuperOrganizationValidator < ActiveModel::Validator
  def validate(record)
  	if not record.new_record? and record.super_organization_id
      s = Organization.all_sub_organization(record.id)
      if s and s.collect {|x| x.id}.include?(record.super_organization_id)
  			record.errors.add :super_organization_id , I18n.t('activerecord.errors.organization.bad_super_organization')
  		end
   	end
  end
end
class Organization < ActiveRecord::Base
	ORGANIZATION_NUM_LIMIT = 100
	validates :name    ,:length => {:maximum => 100}, :presence => true
	validates :address ,:length => {:maximum => 200}
	#validates :manager ,:presence => true
	belongs_to :tenant
	belongs_to :manager,:class_name =>"User",:inverse_of => :organization
	belongs_to :super_organization,:class_name =>"Organization"
	has_many  :sub_organizations,:class_name => "Organization",:foreign_key => "super_organization_id"
	default_scope { where(tenant_id: Tenant.current_id)  if Tenant.current_id }

	validates_with SuperOrganizationValidator


  def self.all_organization_users(organization_id)
    return [] if  (organization_id.nil? or organization_id.to_s.length == 0)
    User.find_by_sql(
       %Q{
           #{Organization.all_sub_organizations_sql("rr",organization_id)}
             select * from users where #{Tenant.current_id ? "users.tenant_id = #{Tenant.current_id} and " : ""}
             (users.organization_id in (select id from rr limit #{ORGANIZATION_NUM_LIMIT}));
          }
    )
  end
	def self.all_organization_except_own_sub_organization(organization_id)
		return Organization.all if  (organization_id.nil? or organization_id.to_s.length == 0)
		Organization.find_by_sql(
			 %Q{
         	 #{Organization.all_sub_organizations_sql("rr",organization_id)}
          	 select * from organizations where #{Tenant.current_id ? "organizations.tenant_id = #{Tenant.current_id} and " : ""}
             id not in (select id from rr limit #{ORGANIZATION_NUM_LIMIT});
        	}
		)
	end
	def self.all_sub_organization(organization_id)
      return [] if (organization_id.nil? or organization_id.to_s.length == 0)
      puts self.all_sub_organizations_sql("rr",organization_id)
      Organization.find_by_sql(
        %Q{
          #{Organization.all_sub_organizations_sql("rr",organization_id)}
          select * from rr limit #{ORGANIZATION_NUM_LIMIT};
        }
      )
    end

	def self.all_sub_organizations_sql(new_table_name,organization_id)
      %Q{
        WITH RECURSIVE #{new_table_name} AS ( 
      SELECT organizations.* FROM organizations WHERE organizations.id = #{organization_id} #{Tenant.current_id ? "and organizations.tenant_id = #{Tenant.current_id}" : ""}
        union   ALL 
        SELECT organizations.* FROM organizations, #{new_table_name} WHERE organizations.super_organization_id =  #{new_table_name}.id
        ) 
      }
  end

end
