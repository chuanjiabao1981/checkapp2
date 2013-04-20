class Organization < ActiveRecord::Base
  belongs_to :tenant
  belongs_to :manager
end
