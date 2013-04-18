class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.string :name
      t.float :lng
      t.float :lat
      t.references :tenant

      t.timestamps
    end
    add_index :locations, :tenant_id

  end
end
