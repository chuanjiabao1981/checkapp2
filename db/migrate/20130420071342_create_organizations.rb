class CreateOrganizations < ActiveRecord::Migration
  def change
    create_table :organizations do |t|
      t.string :name
      t.string :address
      t.references :tenant
      t.references :manager

      t.timestamps
    end
    add_index :organizations, :tenant_id
    add_index :organizations, :manager_id
  end
end
