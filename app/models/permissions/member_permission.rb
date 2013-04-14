module Permissions
  class MemberPermission < BasePermission
    def initialize(user)
      allow :sessions,[:new,:create,:destroy]
      allow :users,[:index]
      allow :main,[:home]
      #allow :issues,[:index,:new,:create]
      #allow :issues,[:edit,:update,:destroy] do |i|
      #	i && i.tenant_id == user.tenant_id && i.submitter_id == user.id
      #end
      allow :resolves,[:new,:create] do |issue|
        issue.tenant_id == user.tenant_id && issue && issue.responsible_person_id  == user.id
      end
      allow :resolves,[:edit,:update] do |resolve|
        resolve.tenant_id == user.tenant_id && resolve && resolve.submitter_id == user.id
      end
      allow :quick_reports,[:index,:new,:create]
      allow :quick_reports,[:edit,:update] do |quick_report|
        quick_report && quick_report.tenant == user.tenant && quick_report.issue && quick_report.issue.submitter_id == user.id
      end
      #allow_param :issue,[:level,:desc,:reject_reason,:deadline,:responsible_person_id,:state_event]
      allow_param :resolve,[:desc]
      allow_nested_param :quick_report,:issue_attributes,[:level,:desc,:reject_reason,:deadline,:responsible_person_id,:state_event,:images_attributes=>[:image]]
    end
  end
end
