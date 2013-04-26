module Permissions
  class MemberPermission < BasePermission
    def initialize(user)
      allow :sessions,[:new,:create,:destroy]
      allow :users,[:index]
      allow :main,[:overview]
      #allow :issues,[:index,:new,:create]
      #allow :issues,[:edit,:update,:destroy] do |i|
      #	i && i.tenant_id == user.tenant_id && i.submitter_id == user.id
      #end
      allow :resolves,[:new,:create] do |issue|
        issue && issue.tenant_id == user.tenant_id && issue.responsible_person && issue.responsible_person.id == user.id && issue.resolve.nil?
      end
      allow :resolves,[:edit,:update] do |resolve|
        resolve && resolve.tenant_id == user.tenant_id && resolve.submitter_id == user.id && resolve.issue && !resolve.issue.closed?
      end
      allow :quick_reports,[:index,:new,:create,:search]
      allow :quick_reports,[:show] do |quick_report|
        quick_report && quick_report.tenant == user.tenant
      end
      allow :quick_reports,[:edit,:update] do |quick_report|
        quick_report && quick_report.tenant == user.tenant && quick_report.issue && quick_report.issue.submitter_id == user.id
      end
      allow :locations,[:index] 
      allow :organizations,[:index]
      allow_param :location,[:search]

      #allow_param :issue,[:level,:desc,:reject_reason,:deadline,:responsible_person_id,:state_event]
      allow_param :resolve,[:desc]
      allow_nested_param :resolve, :images_attributes,[:image,:id]
      allow_nested_param :quick_report,:issue_attributes,[:id,:level,:desc,:reject_reason,:deadline,:responsible_person_id,:location_id,:state_event,:images_attributes=>[:image,:id]]
    end
  end
end
