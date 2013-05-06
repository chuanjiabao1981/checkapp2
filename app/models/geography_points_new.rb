module GeographyPointsNew
	def new(attributes = nil, options = {}) 
			s= super(attributes,options)
			if attributes and attributes[:lng] and attributes[:lat]
				s.coordinate="POINT(#{attributes[:lng]} #{attributes[:lat]})"
			end
			s
	end
end