class CreateCheckPoints < ActiveRecord::Migration
  def change
    create_table :check_points do |t|
      t.string :content
      t.references :tenant
      t.references :template

      t.timestamps
    end
    add_index :check_points, :tenant_id
    add_index :check_points, :template_id
  end
end
