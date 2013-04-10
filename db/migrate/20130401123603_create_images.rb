class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.string :image
      t.references :image_attachment, :polymorphic => true
      t.references :tenant

      t.timestamps
    end
    add_index :images, :image_attachment_id
    add_index :images, :tenant_id
  end
end
