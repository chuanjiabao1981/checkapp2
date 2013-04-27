module MainHelper
	def needed_resolve_quick_report_num
		@_needed_resolve_quick_report_num ||=QuickReport.by_state("needed_resolve").by_responsible_person(current_user.id.to_s).count
	end
	def needed_verify_quick_report_num
		@_needed_verify_quick_report_num ||=QuickReport.by_state("needed_verify").by_submitter(current_user.id.to_s).count
	end
	def total_needed_handle_quick_report_num
		needed_resolve_quick_report_num + needed_verify_quick_report_num
	end
end
