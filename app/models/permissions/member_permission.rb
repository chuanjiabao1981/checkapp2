module Permissions
  class MemberPermission < BasePermission
    def initialize(user)
      allow :sessions,[:new,:create,:destroy]
      allow "api/v1/sessions",[:create,:destroy]
      allow "api/v1/track_points",[:create]
      allow "api/v1/organizations",[:users]
      
      allow :images,[:create]
      
      allow :images,[:destroy] do |image|
        image && image.tenant_id == user.tenant_id
      end

      allow :users,[:index,:track,:checkin]
      allow :templates,[:index]
      allow :templates,[:show] do |t|
        t && t.tenant == user.tenant
      end
      allow :template_reports,[:index,:new,:create,:search]
      allow :template_reports,[:show] do |t|
        t && t.tenant_id == user.tenant_id
      end
      allow :template_check_records,[:new,:create] do |tr|
        tr && tr.tenant_id == user.tenant_id && tr.submitter_id = user.id
      end
      #编辑利息检查记录的时候,如果是管理员就直接可以编辑，不需要是同一个人；若非管理员则必须是同一个人
      allow :template_check_records,[:edit,:update] do |tcr|
        tcr && tcr.tenant_id == user.tenant_id && tcr.submitter_id == user.id
      end
      allow :template_check_records,[:show] do |tcr|
        tcr && tcr.tenant_id == user.tenant_id
      end

      allow_param :template_check_record,[:check_point_id,:location_id,:desc,:state]
      allow_nested_param :template_check_record,:images_attributes,[:image,:id,:_destroy]
      allow_nested_param :template_check_record,:issue_attributes,[:id,:level,:desc,:reject_reason,:deadline,:responsible_person_id,:location_id,:state_event,:organization_id,:images_attributes=>[:image,:id,:_destroy]]



      allow_param :template_report,[:template_id]

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
      allow_nested_param :resolve, :images_attributes,[:image,:id,:_destroy]
      allow_nested_param :quick_report,:issue_attributes,[:id,:level,:desc,:reject_reason,:deadline,:responsible_person_id,:location_id,:state_event,:organization_id,:images_attributes=>[:image,:id,:_destroy]]
    end
  end
end
