#encoding:utf-8
class TenantValidator < ActiveModel::Validator
  def validate(record)
    if not record.tenant.nil? and record.role and record.role.name == Role::SuperAdmin 
    	record.errors.add :tenant , I18n.t('activerecord.errors.messages.super_admin_with_tenant')
    end
  end
end
class ManagerValidator < ActiveModel::Validator
  def validate(record)
    if not record.manager.nil? and record.tenant_id != record.manager.tenant_id
      record.errors.add :manager_id, I18n.t('activerecord.errors.messages.tenant_not_match')
    end
  end
end
class User < ActiveRecord::Base
	VALID_NAME_REGEX = /\A[a-zA-Z\d_]+\z/i
	VALID_MOBILE_REGEX = /\A[\d]+\z/

	#attr_accessible :account,:password,:password_confirmation,:mobile,:name,:role,:manager,:tenant

	before_save :create_remember_token

	has_secure_password

  validates :name    ,:length => {:maximum => 50}
  validates :mobile  ,:length => {:is => 11 },format: {with:VALID_MOBILE_REGEX} , :unless => "mobile.nil?"
  validates :account ,:length => {:maximum => 50},:presence => true,:uniqueness => true,format:{with:VALID_NAME_REGEX}
 	#validates :password_confirmation,presence:true,:unless=>"password==''"
  validates :role    ,presence: true
	validates :tenant  ,presence: true, :unless => Proc.new {|u| u.role && u.role.name == Role::SuperAdmin}

  
	validates_with TenantValidator
  validates_with ManagerValidator

  belongs_to  :role
	has_many 	  :subordinates, :class_name => "User", :foreign_key => "manager_id",:dependent => :destroy
	belongs_to  :manager,:class_name =>"User"
  belongs_to  :tenant


  default_scope { where(tenant_id: Tenant.current_id)  if Tenant.current_id }

    #一个租户的admin  只能通过 super_admin添加


    #def add_user(option={})
    #	a = User.new(option)
    #	# admin 只能创建同tenant下的 member用户 这个由default保证
    #	a.tenant = self.tenant 			if self.admin?
    #	a.role  = Role.get_member if self.admin? 
    #	# super_admin 只能创建admin
    #	a.role  = Role.get_admin  if self.super_admin?
    #	a
    #end	

    def self.new_user(user,option={})
      a = User.new(option)
      # admin 只能创建同tenant下的 member用户 这个由default保证
      a.tenant = user.tenant      if user.admin?
      a.role  = Role.get_member if user.admin? 
      # super_admin 只能创建admin
      a.role  = Role.get_admin  if user.super_admin?
      a     
    end

    def member?
      is_role?(Role::Member)
    end
    def admin?
    	is_role?(Role::Admin)
    end
    def super_admin?
    	is_role?(Role::SuperAdmin)
    end

  	private 
  		def create_remember_token
  			self.remember_token =  SecureRandom.urlsafe_base64
  		end
  		def is_role?(role_name)
  			self.role && self.role.name == role_name
  		end
end
