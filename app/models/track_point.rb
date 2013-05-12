#encoding:utf-8
class TrackPoint < ActiveRecord::Base
	belongs_to :tenant
	belongs_to :user

	validates_presence_of :lng
	validates_presence_of :lat
	validates_presence_of :interval_time_between_generate_and_submit
	validates_presence_of :generated_time_of_client_version

	#validates_numericality_of :lng
	#validates_numericality_of :lat
	validates_numericality_of :radius

	validates_numericality_of :interval_time_between_generate_and_submit
	validates_numericality_of :generated_time_of_client_version

	default_scope { where(tenant_id: Tenant.current_id)  if Tenant.current_id }


	scope :between, lambda { |day,start_time,end_time| 
						     order('generated_time_of_server_version ASC').where('generated_time_of_server_version between ? and ?',TrackPoint.parser_time(day,start_time,Time.now.beginning_of_day),TrackPoint.parser_time(day,end_time,Time.now)) unless start_time.nil? or end_time.nil? }

	scope :by_user, lambda { |user| 
							 where('user_id = ?' ,user) 
	}
	scope :by_radius,lambda{|radius| 
		if radius 
			where('radius <= ?',radius)
		else
			where('radius <= 150')
		end
	}

	scope :by_distance,lambda { |center,radius|
		where("ST_DWithin(ST_GeographyFromText('SRID=4326;#{center.to_s}'),coordinate,#{radius})");
	}
	scope :group_by_check_in_time ,group("checkin_time,user_id")
	scope :by_users, lambda { |users| where(:user_id => users) }
	scope :between_day,lambda {|start_day,end_day| 
		where('generated_time_of_server_version between ? and ?',
			TrackPoint.parser_time(start_day,"00:00", DateTime.now.beginning_of_day.utc),
			TrackPoint.parser_time(end_day,"23:59",DateTime.now.end_of_day.utc)
		)
	}
	include GeographyPoints
	extend GeographyPointsNew

	validates_with CoordinateValidator

	def self.build_track_list(current_user,points)
		k = []
		points.each_with_index do |point,index|
			next if point[:coortype] == 'unknown'
			if point[:generated_time_of_client_version]
				begin
					point[:generated_time_of_client_version]=DateTime.strptime(point[:generated_time_of_client_version].to_s,"%s")
				rescue
					return [false,{"generated_time_of_client_version" => ["格式错误"],"index"=>[index]}]
				end
			end
			#_p = current_user.track_points.build(point)
			_p = TrackPoint.new(point)
			_p.user_id = current_user.id
			if _p.valid?
				_p.generated_time_of_server_version = Time.now - _p.interval_time_between_generate_and_submit
				k << _p
			else
				_e				= _p.errors
				_e[:index] 		= index
				return [false,_e]
			end
		end
		[true,k]
	end

	 
	def self.parser_time(day,time,default)
		begin
			DateTime.parse(Time.new(*(day.split('-')+time.split(':'))).utc.to_s)
		rescue
			default
		end
	end
	def self.worker_checkin_info()
		_center 		=  'POINT(113.589385 37.862176)'
		_distance		=  100
		_user 			=  2
		_start_day      =  '2013-04-11' 
		_end_day		=  '2013-05-11'
		TrackPoint.select(%Q{min(generated_time_of_server_version) as first_checkin , user_id ,to_char(generated_time_of_server_version,'YYYY-MM-DD') as checkin_time})
		.by_distance(_center,_distance)
	    .group_by_check_in_time
	    .by_user(_user)
	    .between_day(_start_day,_end_day)
	end
	def self.test(organization_id)
		_organization_users = 'organization_users'
		TrackPoint.find_by_sql(
			%Q{
				#{User.all_subordinates_sql(_organization_users,organization_id)}
				select * from #{_organization_users}
			}
		)
	end
end
