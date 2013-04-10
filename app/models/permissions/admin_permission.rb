module Permissions
  class AdminPermission < BasePermission
    def initialize(user)
      allow :users, [:index,:new,:create]
      allow :users, [:edit,:update,:destroy] do |u|
      	u && u.tenant == user.tenant
      end
      allow_param :user ,[:name,:mobile,:account,:password_confirmation,:password,:manager_id]

      allow :sessions,[:new,:create,:destroy]
      allow :main,[:home]
    end
  end
end