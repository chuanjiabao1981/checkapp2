#encoding:utf-8
class TrackPoint < ActiveRecord::Base
	belongs_to :tenant
	belongs_to :user

	validates_presence_of :lng
	validates_presence_of :lat
	validates_presence_of :interval_time_between_generate_and_submit
	validates_presence_of :generated_time_of_client_version

	validates_numericality_of :lng
	validates_numericality_of :lat
	validates_numericality_of :radius

	validates_numericality_of :interval_time_between_generate_and_submit
	validates_numericality_of :generated_time_of_client_version

	default_scope { where(tenant_id: Tenant.current_id)  if Tenant.current_id }




	def self.build_track_list(current_user,points)
		k = []
		points.each_with_index do |point,index|
			if point[:generated_time_of_client_version]
				begin
					point[:generated_time_of_client_version]=DateTime.strptime(point[:generated_time_of_client_version].to_s,"%s")
				rescue
					return [false,{"generated_time_of_client_version" => ["格式错误"],"index"=>[index]}]
				end
			end
			_p = current_user.track_points.build(point)
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
end
