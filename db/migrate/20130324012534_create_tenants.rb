class CreateTenants < ActiveRecord::Migration
  def change
    create_table :tenants do |t|
      t.string :name
      t.date :term
      t.point :coordinate,:geographic => true,:srid=>4326 ,:default => "POINT(116.404 39.915)"
      t.integer 	    :zoom,   :default => 15
      t.timestamps
    end
  end
end
