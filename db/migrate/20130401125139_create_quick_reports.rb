class CreateQuickReports < ActiveRecord::Migration
  def change
    create_table :quick_reports do |t|
      t.references :tenant

      t.timestamps
    end
    add_index :quick_reports, :tenant_id
  end
end
