class CreateResolves < ActiveRecord::Migration
  def change
    create_table :resolves do |t|
      t.text :desc
      t.references :submitter
      t.references :issue
      t.references :tenant

      t.timestamps
    end
    add_index :resolves, :submitter_id
    add_index :resolves, :issue_id
    add_index :resolves, :tenant_id
  end
end
