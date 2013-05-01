module Api
	module V1
		class TrackPointsController < ApiController
			def create
				status,data = TrackPoint.build_track_list(current_user,params[:track_points])
				if status
					data.each do |t|
						t.save
					end
					return render json:json_response_ok
				else
					return render json:json_errors(data)
				end
			end
		end
	end
end