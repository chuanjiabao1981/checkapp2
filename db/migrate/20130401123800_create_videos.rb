class CreateVideos < ActiveRecord::Migration
  def change
    create_table :videos do |t|
      t.string :video
      t.references :video_attachment, :polymorphic => true
      t.references :tenant

      t.timestamps
    end
    add_index :videos, :video_attachment_id
    add_index :videos, :tenant_id
  end
end
