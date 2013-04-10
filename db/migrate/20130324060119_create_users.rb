class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :account
      t.string :password_digest
      t.string :remember_token
      t.string :name
      t.string :mobile
      t.references :tenant
      t.integer :manager_id

      t.timestamps
    end
    add_index :users, :tenant_id
  end
end
