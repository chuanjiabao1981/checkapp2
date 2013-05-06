#encoding:utf-8
module GeographyPoints
	attr_accessor :lat
	attr_accessor :lng
	def lat
		self.coordinate.try(:y)
	end
	def lng
		self.coordinate.try(:x)
	end
	##s.to_json(:methods=>[:lat,:lng],:only=>[:name])

	def update_attributes(attributes)
		if attributes[:lng] and attributes[:lat]
			self.coordinate="POINT(#{attributes[:lng]} #{attributes[:lat]})"
		end
		super(attributes)
	end

	class CoordinateValidator < ActiveModel::Validator
  		def validate(record)
  		  if record.coordinate.nil?
  		    record.errors[:base] << '经纬度错误'
  		  end
  		end
	end
end