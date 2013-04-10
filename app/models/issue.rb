#encoding:utf-8
class Issue < ActiveRecord::Base

	ISSUE_STATE_OPEN		= "未处理"
	ISSUE_STATE_PROCESS		= "处理中"

	ISSUE_STATE_SET=%w(未处理 处理中 解决)
	ISSUE_LEVEL_SET=%W(高 中 低)

	before_create :issue_opened_action

	#validates :state,:inclusion => { :in => ISSUE_STATE_SET, 
	#								 :message => "%{value} is not a valid state" }
	#validates :level,:inclusion => { :in =>ISSUE_LEVEL_SET ,
	#								 :message => "%{value} is not a valid "}

	validates :desc,:length => {:maximum => 1024}
	validates_date :deadline,:on_or_after => lambda { Date.current }
	validates :issuable, :presence => true
	validates :tenant, :presence => true
	validates :finder,:presence => true

	belongs_to :responsible_person, 	:class_name=>"User",:foreign_key => "responsible_person_id"
	belongs_to :finder,	:class_name=>"User",:foreign_key => "finder_id"
	belongs_to :issuable,:polymorphic => true
	belongs_to :tenant


	has_many :videos,:as => :video_attachment,:dependent => :destroy
	has_many :images,:as => :image_attachment,:dependent => :destroy
	has_one  :resolve,:dependent => :destroy #,:inverse_of => :issue

	default_scope { where(tenant_id: Tenant.current_id)  if Tenant.current_id }


	state_machine :initial => :opened do  
		after_transition any  => :opened 					,:do => :issue_opened_action
		after_transition any  => :verifying_resolve			,:do => :send_message_to_finder 
		after_transition any  => :closed 					,:do => :send_message_to_responsible_person
		after_transition  any  => :resolve_denied			,:do => :send_message_to_responsible_person
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
		end
		state :closed do
			transition :to => :resolve_denied		,			:on => :reject_resolve
			validates_presence_of :responsible_person

		end
		state :resolve_denied do
			transition :to => :verifying_resolve	,			:on => :commit_resolve
			transition :to => :opened 				,			:on => :change_responsible_person
			validates_presence_of :responsible_person
		end
	end

	def issue_opened_action
		#Rails.logger.debug(self.new_record?)
		if not self.new_record?
			self.resolve.destroy unless self.resolve.nil?
		end
		#Rails.logger.debug("=========================================#{self.state}")
		self.send_message_to_responsible_person
	end
	def send_message_to_finder
		self.message_for_finder=self.state #test
		Rails.logger.debug("Send Message to finder #{self.finder.name}@#{self.finder.mobile}")
	end
	def send_message_to_responsible_person
		self.message_for_responsible_person=self.state #test
		Rails.logger.debug("Send Message to responsible_person #{self.responsible_person.name}@#{self.responsible_person.mobile}")
	end

	#for test
	def message_for_responsible_person=(m)
		@message_for_responsible_person=m
	end
	def message_for_responsible_person
		@message_for_responsible_person
	end

	def message_for_finder=(m)
		@message_for_finder=m
	end
	def message_for_finder
		@message_for_finder
	end
end
