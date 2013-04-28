class AddLatLngLevelToTenants < ActiveRecord::Migration
  def change
  	add_column :tenants, :lng, 			:float ,:default => 116.404
  	add_column :tenants, :lat, 			:float ,:default => 39.915
  	add_column :tenants, :zoom, 	    :int,   :default => 15
  end
end
