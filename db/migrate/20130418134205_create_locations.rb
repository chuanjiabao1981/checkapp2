class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.string :name
      t.point :coordinate,:geographic => true,:srid=>4326
      t.references :tenant

      t.timestamps
    end
    add_index :locations, :tenant_id
    add_index :locations, :coordinate, :spatial => true

  end
end
