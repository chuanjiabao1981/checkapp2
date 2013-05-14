class AddPrefixAndTile < ActiveRecord::Migration
  def up
  	add_column :tenants,:prefix,:string
  	add_column :tenants,:tile,:boolean,:default => false
  end

  def down
  	remove_column :tenants,:prefix
  	remove_column :tenants,:tile
  end
end
