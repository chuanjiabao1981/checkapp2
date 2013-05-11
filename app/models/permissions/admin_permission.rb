#encoding:utf-8
module Permissions
  class AdminPermission < BasePermission
    def initialize(user)
      allow :users, [:index,:new,:create,:track,:checkin,:add_track_point]
      allow :users, [:edit,:update,:destroy] do |u|
      	u && u.tenant == user.tenant
      end

      allow :templates,[:index,:new,:create]
      allow :templates,[:show,:edit,:update,:destroy] do |t|
        t && t.tenant_id == user.tenant_id
      end
      allow :template_reports,[:index,:new,:create,:search]
      allow :template_reports,[:show,:destroy] do |t|
        t && t.tenant_id == user.tenant_id
      end
      #创建例行检查记录的时候,当前人员必须和例行检查报告是同一个人
      allow :template_check_records,[:new,:create] do |tr|
        tr && tr.tenant_id == user.tenant_id && tr.submitter_id = user.id
      end
      #编辑利息检查记录的时候,如果是管理员就直接可以编辑，不需要是同一个人；若非管理员则必须是同一个人
      allow :template_check_records,[:edit,:update] do |tcr|
        tcr && tcr.tenant_id == user.tenant_id
      end
      allow :template_check_records,[:destroy,:show] do |tcr|
        tcr && tcr.tenant_id == user.tenant_id
      end
      allow_param :template_check_record,[:check_point_id,:location_id,:desc,:state]
      allow_nested_param :template_check_record,:images_attributes,[:image,:id,:_destroy]
      allow_nested_param :template_check_record,:issue_attributes,[:id,:level,:desc,:reject_reason,:deadline,:responsible_person_id,:location_id,:state_event,:organization_id,:images_attributes=>[:image,:id,:_destroy]]


      allow_param :template_report,[:template_id]
      allow_param :template,[:name,:desc]
      allow_param :user ,[:name,:mobile,:account,:password_confirmation,:password,:manager_id]

      allow :sessions,[:new,:create,:destroy]
      allow "api/v1/sessions",[:create,:destroy]
      allow "api/v1/track_points",[:create]
      allow "api/v1/organizations",[:users]

      allow :main,[:overview]
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

      allow :check_points,[:new,:create] do |template|
        template && template.tenant_id == user.tenant_id
      end
      allow :check_points,[:edit,:update,:destroy] do |check_point|
        check_point && check_point.tenant_id == user.tenant_id
      end
      allow_param :check_point,[:content]
      allow :quick_reports,[:index,:new,:create,:search]
      allow :quick_reports,[:edit,:update,:destroy,:show]  do |quick_report|
        quick_report && quick_report.tenant_id == user.tenant_id
      end
      allow :locations,[:index,:new,:create] 
      allow :locations,[:edit,:update,:destroy] do |location|
        location && location.tenant_id == user.tenant_id
      end
      allow_param :location,[:name,:lat,:lng,:search]

      allow :organizations,[:index,:new,:create]
      allow :organizations,[:edit,:update,:destroy] do |organization|
        organization && organization.tenant_id == user.tenant_id
      end
      allow_param :organization ,[:name,:address,:manager_id]


      allow_param :resolve,[:desc]
      allow_nested_param :resolve, :images_attributes,[:image,:id,:_destroy]
      allow_nested_param :quick_report,:issue_attributes,[:id,:level,:desc,:reject_reason,:deadline,:responsible_person_id,:location_id,:state_event,:organization_id,:images_attributes=>[:image,:id,:_destroy]]
    end
  end
end