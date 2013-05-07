class AddOrganizationToIssue < ActiveRecord::Migration
  def change
  	add_column :issues,:organization_id,:integer
  	add_index  :issues,:organization_id
  end
end
