module ScopeLib
	module Issue
		def self.included(base)
			base.class_eval do
				scope :by_location, lambda {|location| joins(:issue).where("issues.location_id = ?",location) unless location.nil? or location.empty? }
				scope :by_level, lambda {|level| joins(:issue).where('issues.level = ?',level) unless level.nil? or level.empty? }
				scope :by_state, lambda {|state| 
					if state == 'needed_verify'
						joins(:issue).where("issues.state =? ", 'verifying_resolve')
					elsif state == 'needed_resolve'
						joins(:issue).where("issues.state = ? or issues.state = ?", "opened","resolve_denied")
					end
				}

				scope :closed_state , lambda { |is_closed| 
					if not is_closed.nil? 
						if is_closed == 'true'
							joins(:issue).where("issues.state = ?","closed")
						elsif is_closed == 'false'
							joins(:issue).where("issues.state != ?","closed")
						end
					end
				}
				#截至到d天前
				scope :day_ago, lambda {|d| joins(:issue).where('issues.created_at < ?',d.day.ago.beginning_of_day) unless d.nil? or d == 0}
				#最近d天的
				scope :last_day ,lambda {|d| joins(:issue).where('issues.created_at >?',d.day.ago.beginning_of_day)}

				scope :exceed_deadline ,lambda { joins(:issue).where('issues.deadline is not null and issues.deadline < ? and issues.state != ? ',Date.current,"closed")}
				scope :group_by_created,lambda { joins(:issue).select('count(*) as num, DATE(issues.created_at) as issue_created_at_date').group('DATE(issues.created_at)')}
				scope :group_by_level, lambda  { joins(:issue).select('count(*) as num, issues.level as level').group('issues.level')}
				scope :by_responsible_person,lambda {|responsible_person_id|
					joins(:issue).
					where("issues.responsible_person_id = ?" , responsible_person_id) unless responsible_person_id.nil? or responsible_person_id.empty?
				}
				scope :by_submitter,lambda {|submitter|
					joins(:issue).
					where("issues.submitter_id = ?",submitter) unless submitter.nil? or submitter.empty?
				}
				scope :needed_resolve,
				lambda {|needed_resolve| 
					joins(:issue).
					where("issues.state = ? or issues.state = ?", "opened","resolve_denied") unless needed_resolve.nil? or needed_resolve =="0"
				}
				scope :needed_verify,
				lambda {|needed_verify|
					joins(:issue).
					where("issues.state =? ", 'verifying_resolve') unless needed_verify.nil? or needed_verify == "0"
				}
			end
		end
	end
end