class CreateTemplates < ActiveRecord::Migration
  def change
    create_table :templates do |t|
      t.string :name
      t.string :desc
      t.references :tenant

      t.timestamps
    end
    add_index :templates, :tenant_id
  end
end
