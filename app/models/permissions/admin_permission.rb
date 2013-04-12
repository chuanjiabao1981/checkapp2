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
      allow :issues,[:index,:new,:create]
      allow :issues, [:show,:edit,:update,:destroy,] do |u|
        u && u.tenant == user.tenant
      end
      allow :resolves,[:new,:create] do |issue|
        issue.tenant_id == user.tenant_id && issue && issue.responsible_person_id  == user.id
      end
      allow :resolves,[:edit,:update] do |resolve|
        resolve.tenant_id == user.tenant_id && resolve && resolve.submitter_id == user.id
      end
      allow_param :resolve,[:desc]
      allow_param :issue,[:level,:desc,:reject_reason,:deadline,:responsible_person_id,:state_event]
    end
  end
end