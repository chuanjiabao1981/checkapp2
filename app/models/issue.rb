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
	has_one  :resolve,:dependent => :destroy ,:inverse_of => :issue

	default_scope { where(tenant_id: Tenant.current_id)  if Tenant.current_id }


	state_machine :initial => :opened do  
		before_transition any => :opened ,:do => :issue_opened_action

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
		self.resolve.destroy unless self.resolve.nil?
		#send message to responsible person
	end

end
