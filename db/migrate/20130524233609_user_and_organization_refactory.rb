class UserAndOrganizationRefactory < ActiveRecord::Migration
  def up
  	Organization.all.each do |o|
  		so = super_organization(o)
  		if so
  			print "#{o.name},#{so.name}\n"
  		else
  			print "#{o.name},no\n"
  		end
  	end
  	puts "------------------------------------------"
  	User.all.each do |u|
  		if u.organization
  			print "#{u.name},#{u.organization.name}\n"
  		else
  			print "#{u.name},#{user_organization(u).try(:name)}\n"
  		end
  	end
  end

  def down
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
