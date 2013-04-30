class CreateTrackPoints < ActiveRecord::Migration
  def change
    create_table :track_points do |t|
      t.float :lat
      t.float :lng
      t.float :radius
      t.string :coortype
      t.references :tenant
      t.references :user
      t.integer    :interval_time_between_generate_and_submit
      t.timestamp :generated_time_of_client_version
      t.timestamp :generated_time_of_server_version

      t.timestamps
    end
    add_index :track_points, :generated_time_of_server_version
    add_index :track_points, :tenant_id
    add_index :track_points, :user_id
  end
end
