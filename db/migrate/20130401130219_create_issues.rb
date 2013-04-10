class CreateIssues < ActiveRecord::Migration
  def change
    create_table :issues do |t|
      t.string :state
      t.string :level
      t.text :desc
      t.date :deadline
      t.references :issuable,:polymorphic => true
      t.references :tenant
      t.references :finder
      t.references :responsible_person 
      t.timestamps
    end
    add_index :issues, :finder_id
    add_index :issues, :responsible_person_id
    add_index :issues, :issuable_id
    add_index :issues, :tenant_id
    add_index :issues, :deadline
  end
end
