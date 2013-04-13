#encoding:utf-8
class Issue < ActiveRecord::Base


	ISSUE_LEVEL_SET=%W(高 中 低)

	before_create :issue_opened_action

	validates :level,:inclusion => { :in =>ISSUE_LEVEL_SET ,
									 :message => "%{value} is not a valid "}

	validates :desc 			,:length => {:maximum => 1024}
	validates :reject_reason	,:length => {:maximum => 1024}
	validates_date :deadline,:on_or_after => lambda { Date.current }
	#validates :issuable, :presence => true
	validates :tenant, :presence => true
	validates :submitter,:presence => true

	validates_presence_of :issuable_type


	belongs_to :responsible_person, 	:class_name=>"User",:foreign_key => "responsible_person_id"
	belongs_to :submitter,	:class_name=>"User",:foreign_key => "submitter_id"
	belongs_to :issuable,:polymorphic => true
	belongs_to :tenant


	has_many :videos,:as => :video_attachment,:dependent => :destroy
	has_many :images,:as => :image_attachment,:dependent => :destroy
	has_one  :resolve,:dependent => :destroy 

	default_scope { where(tenant_id: Tenant.current_id)  if Tenant.current_id }


	state_machine :initial => :opened do  
		after_transition any  => :opened 					,:do => :issue_opened_action
		after_transition any  => :verifying_resolve			,:do => :send_message_to_submitter 
		after_transition any  => :closed 					,:do => :send_message_to_responsible_person
		after_transition any  => :resolve_denied			,:do => :send_message_to_responsible_person
		around_transition do |issue, transition, block|
      		Rails.logger.debug "before #{transition.event}: #{issue.state}"
      		block.call
      		Rails.logger.debug "after #{transition.event}: #{issue.state}"
    	end

		state :opened do
			transition :to => :opened ,:on => :change_responsible_person
			transition :to => :verifying_resolve, :on => :commit_resolve
		end
		state :verifying_resolve do
			transition :to => :opened 		 		,			:on => :change_responsible_person
			transition :to => :closed 		 		,			:on => :close
			transition :to => :resolve_denied		,			:on => :reject_resolve
			validates_presence_of :responsible_person
			validates_presence_of :resolve
		end
		state :closed do
			transition :to => :resolve_denied		,			:on => :reject_resolve
			validates_presence_of :responsible_person
			validates_presence_of :resolve
		end
		state :resolve_denied do
			transition :to => :verifying_resolve	,			:on => :commit_resolve
			transition :to => :opened 				,			:on => :change_responsible_person
			validates_presence_of :responsible_person
		end
	end
	private 
		def issue_opened_action
			#Rails.logger.debug(self.new_record?)
			if not self.new_record?
				self.resolve.destroy unless self.resolve.nil?
			end
			send_message_to_responsible_person
		end
		def send_message_to_submitter
			self.message_for_submitter=self.state #test
			Rails.logger.debug("Send Message to submitter #{self.submitter.name}@#{self.submitter.mobile}")
		end
		def send_message_to_responsible_person
			self.message_for_responsible_person=self.state #test
			if self.responsible_person
				Rails.logger.debug("Send Message to responsible_person #{self.responsible_person.name}@#{self.responsible_person.mobile}")
			end
		end
		def issue_responsible_person_change_detect
			self.responsible_person_id.change?
		end
	public 
		#for test
		def message_for_responsible_person=(m)
			@message_for_responsible_person=m
		end
		def message_for_responsible_person
			@message_for_responsible_person
		end
		def message_for_submitter=(m)
			@message_for_submitter=m
		end
		def message_for_submitter
			@message_for_submitter
		end
end
