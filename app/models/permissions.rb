module Permissions
  def self.permission_for(user)
    if user.nil?
      GuestPermission.new
    elsif user.member?
      MemberPermission.new(user)
    elsif user.admin?
      AdminPermission.new(user)
    elsif user.super_admin?
      SuperAdminPermission.new(user)
    else
      GuestPermission.new
    end
  end
end