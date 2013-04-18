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
        issue && issue.tenant_id == user.tenant_id && issue.responsible_person && issue.responsible_person.id == user.id && issue.resolve.nil?
      end
      allow :resolves,[:edit,:update] do |resolve|
        resolve && resolve.tenant_id == user.tenant_id 
      end

      allow :quick_reports,[:index,:new,:create]
      allow :quick_reports,[:edit,:update,:destroy,:show]  do |quick_report|
        quick_report && quick_report.tenant_id == user.tenant_id
      end
      allow :locations,[:index,:new,:create] 
      allow_param :location,[:name,:lat,:lng]

      allow_param :resolve,[:desc]
      allow_nested_param :quick_report,:issue_attributes,[:id,:level,:desc,:reject_reason,:deadline,:responsible_person_id,:state_event,:images_attributes=>[[:image],:id]]
    end
  end
end