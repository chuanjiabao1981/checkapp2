class CreateTemplateReports < ActiveRecord::Migration
  def change
    create_table :template_reports do |t|
      t.references :template
      t.references :submitter
      t.references :tenant

      t.timestamps
    end
    add_index :template_reports, :template_id
    add_index :template_reports, :submitter_id
    add_index :template_reports, :tenant_id
  end
end
