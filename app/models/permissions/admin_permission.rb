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
      #allow :issues,[:index,:new,:create]
      #allow :issues, [:show,:edit,:update,:destroy,] do |u|
      #  u && u.tenant == user.tenant
      #end
      allow :resolves,[:new,:create] do |issue|
        issue.tenant_id == user.tenant_id && issue && issue.responsible_person_id  == user.id
      end
      allow :resolves,[:edit,:update] do |resolve|
        resolve && resolve.tenant_id == user.tenant_id 
      end

      allow :quick_reports,[:index,:new,:create]
      allow :quick_reports,[:edit,:update,:destroy]  do |quick_report|
        quick_report && quick_report.tenant_id == user.tenant_id
      end
      allow_param :resolve,[:desc]
      allow_nested_param :quick_report,:issue_attributes,[:id,:level,:desc,:reject_reason,:deadline,:responsible_person_id,:state_event,:images_attributes=>[[:image],:id]]
    end
  end
end