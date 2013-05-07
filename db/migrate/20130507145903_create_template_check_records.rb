class CreateTemplateCheckRecords < ActiveRecord::Migration
  def change
    create_table :template_check_records do |t|
      t.references :template_report
      t.references :check_point
      t.references :submitter
      t.references :tenant
      t.string :state
      t.text :desc

      t.timestamps
    end
    add_index :template_check_records, :template_report_id
    add_index :template_check_records, :check_point_id
    add_index :template_check_records, :submitter_id
    add_index :template_check_records, :tenant_id
  end
end
