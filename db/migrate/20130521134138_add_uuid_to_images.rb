class AddUuidToImages < ActiveRecord::Migration
  def change
  	add_column :images,:uuid,:string
  	add_index :images, :uuid
  end
end
