class TemplateCheckRecord < ActiveRecord::Base
		include ScopeLib::Issue

	belongs_to :template_report
	belongs_to :check_point
	belongs_to :submitter,	:class_name=>"User",:foreign_key => "submitter_id"
	belongs_to :tenant
	belongs_to :location

	has_one  :issue	,	:as => :issuable, :dependent => :destroy
	has_many :videos,	:as => :video_attachment,:dependent => :destroy
	has_many :images,	:as => :image_attachment,:dependent => :destroy

	validates :template_report    ,presence: true
	validates :submitter 		  ,presence: true
	validates :check_point		  ,presence: true
	validates :desc 			,:length => {:maximum => 1024}

	accepts_nested_attributes_for :images, allow_destroy: true

	accepts_nested_attributes_for :issue

	default_scope { where(tenant_id: Tenant.current_id)  if Tenant.current_id }
	state_machine :initial => :passed do
		after_transition any  => :passed 					,:do => :check_passed_action
		after_transition any  => :unpassed 					,:do => :check_unpassed_action
		around_transition do |template_check_record, transition, block|
      		Rails.logger.debug "before #{transition.event}: #{template_check_record.state}"
      		block.call
      		Rails.logger.debug "after #{transition.event}: #{template_check_record.state}"
    	end
    	state :passed do
    		transition :to => :unpassed ,:on => :find_some_defects
    		transition :to => :passed   ,:on => :find_no_defect
    	end
    	state :unpassed do 
    		transition :to => :passed 	,:on => :find_no_defect
    		transition :to => :unpassed ,:on => :find_some_defects
    	end
	end	
	scope :by_unpassed_state ,where(:state => 'unpassed')
	def self.search(options)
		TemplateCheckRecord.includes(:issue=>[:submitter,:responsible_person,:resolve]).closed_state(options["is_closed"]).
					by_unpassed_state.
					by_location(options[:location]).
					by_state(options[:state]).
					by_level(options[:level]).
					by_responsible_person(options[:responsible_person]).
					by_submitter(options[:submitter])
	end

	def check_passed_action
		Rails.logger.debug("===================================================")
		self.issue.destroy unless self.issue.nil?
		Rails.logger.debug("===================================================")
	end
	def check_unpassed_action
	end
	def update_attributes(attributes)
		old_check_point_id 		= self.check_point_id
		self.attributes    		= attributes
		self.check_point_id 	= old_check_point_id
		if not self.issue.nil?
			self.issue.submitter_id = self.template_report.submitter_id
		end
		save
	end
	def self.build_a_record(attributes,template_report)
		a = template_report.template_check_records.build(attributes)
		if not template_report.template.check_points.index {|cp| cp.id == a.check_point_id.to_i}
			a.check_point_id     = nil
		end
		a.submitter_id       = template_report.submitter_id
		if not a.issue.nil?
			a.issue.submitter_id = template_report.submitter_id
		end
		a
	end
	def self.state_collection
			s = []
			%W(passed unpassed).each do |i|
				s << [TemplateCheckRecord.human_state_name(i),i]
			end
			s
	end

end
