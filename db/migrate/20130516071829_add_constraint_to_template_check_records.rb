class AddConstraintToTemplateCheckRecords < ActiveRecord::Migration
  def up
  	execute <<-SQL
  		ALTER TABLE template_check_records ADD CONSTRAINT template_report_id_and_check_point_id UNIQUE (template_report_id,check_point_id)
  	SQL
  end
  def down
  	execute <<-SQL
  		ALTER TABLE template_check_records DROP CONSTRAINT template_report_id_and_check_point_id;
  	SQL
  end
end
