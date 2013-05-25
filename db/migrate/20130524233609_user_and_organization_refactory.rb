class UserAndOrganizationRefactory < ActiveRecord::Migration
  def up
  	add_column :organizations,:super_organization_id,:integer
  	add_column :users,:organization_id,:integer

  	add_index :organizations, :super_organization_id
  	add_index :users,:organization_id


  	Organization.all.each do |o|
  		so = super_organization(o)
  		if so
  			o.super_organization_id = so.id
  			o.save
  			print "#{o.name},#{so.name}\n"
  		else
  			print "#{o.name},no\n"
  		end
  	end
  	puts "------------------------------------------"
  	User.all.each do |u|
  		if u.organization
  			u.organization_id = u.organization.id
  			print "#{u.name},#{u.organization.name}\n"
  			u.save
  		else
  			_t = user_organization(u)
  			if _t
  				u.organization_id = _t.id
  				u.save
  			end
  			print "#{u.name},#{_t.try(:name)}\n"
  		end
  	end

  	puts "======================================"
  	Organization.all.each do |o|
  		print "#{o.name},#{o.super_organization_id}\n"
  	end
  	puts "------------------------------------------"

  	User.all.each do |u|
  		print "#{u.name},#{u.organization_id}\n"
  	end
  end

  def down
  	remove_column :users,:organization_id
  	remove_column :organizations,:super_organization_id
  end


  def user_organization(u)
  	if u.manager.nil?
  		return nil
  	elsif u.manager.organization
  		return u.manager.organization
  	else
  		user_organization(u.manager)
  	end
  end
  def super_organization(o)
  	if o.manager
  		user_organization(o.manager)
  	else
  		nil
  	end
  end
end
