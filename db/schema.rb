# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130524233609) do

  create_table "check_points", :force => true do |t|
    t.string   "content"
    t.integer  "tenant_id"
    t.integer  "template_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "check_points", ["template_id"], :name => "index_check_points_on_template_id"
  add_index "check_points", ["tenant_id"], :name => "index_check_points_on_tenant_id"

  create_table "images", :force => true do |t|
    t.string   "image"
    t.integer  "image_attachment_id"
    t.string   "image_attachment_type"
    t.integer  "tenant_id"
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
    t.string   "uuid"
  end

  add_index "images", ["image_attachment_id"], :name => "index_images_on_image_attachment_id"
  add_index "images", ["tenant_id"], :name => "index_images_on_tenant_id"
  add_index "images", ["uuid"], :name => "index_images_on_uuid"

  create_table "issues", :force => true do |t|
    t.string   "state"
    t.string   "level"
    t.text     "desc"
    t.text     "reject_reason"
    t.date     "deadline"
    t.integer  "issuable_id"
    t.string   "issuable_type"
    t.integer  "tenant_id"
    t.integer  "submitter_id"
    t.integer  "responsible_person_id"
    t.integer  "location_id"
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
    t.integer  "organization_id"
  end

  add_index "issues", ["deadline"], :name => "index_issues_on_deadline"
  add_index "issues", ["issuable_id"], :name => "index_issues_on_issuable_id"
  add_index "issues", ["location_id"], :name => "index_issues_on_location_id"
  add_index "issues", ["organization_id"], :name => "index_issues_on_organization_id"
  add_index "issues", ["responsible_person_id"], :name => "index_issues_on_responsible_person_id"
  add_index "issues", ["submitter_id"], :name => "index_issues_on_submitter_id"
  add_index "issues", ["tenant_id"], :name => "index_issues_on_tenant_id"

  create_table "locations", :force => true do |t|
    t.string   "name"
    t.spatial  "coordinate", :limit => {:srid=>4326, :type=>"point", :geographic=>true}
    t.integer  "tenant_id"
    t.datetime "created_at",                                                             :null => false
    t.datetime "updated_at",                                                             :null => false
  end

  add_index "locations", ["coordinate"], :name => "index_locations_on_coordinate", :spatial => true
  add_index "locations", ["tenant_id"], :name => "index_locations_on_tenant_id"

  create_table "organizations", :force => true do |t|
    t.string   "name"
    t.string   "address"
    t.integer  "tenant_id"
    t.integer  "manager_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "organizations", ["manager_id"], :name => "index_organizations_on_manager_id"
  add_index "organizations", ["tenant_id"], :name => "index_organizations_on_tenant_id"

  create_table "quick_reports", :force => true do |t|
    t.integer  "tenant_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "quick_reports", ["tenant_id"], :name => "index_quick_reports_on_tenant_id"

  create_table "resolves", :force => true do |t|
    t.text     "desc"
    t.integer  "submitter_id"
    t.integer  "issue_id"
    t.integer  "tenant_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "resolves", ["issue_id"], :name => "index_resolves_on_issue_id"
  add_index "resolves", ["submitter_id"], :name => "index_resolves_on_submitter_id"
  add_index "resolves", ["tenant_id"], :name => "index_resolves_on_tenant_id"

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.integer  "level"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "template_check_records", :force => true do |t|
    t.integer  "template_report_id"
    t.integer  "check_point_id"
    t.integer  "submitter_id"
    t.integer  "tenant_id"
    t.string   "state"
    t.text     "desc"
    t.integer  "location_id"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  add_index "template_check_records", ["check_point_id"], :name => "index_template_check_records_on_check_point_id"
  add_index "template_check_records", ["location_id"], :name => "index_template_check_records_on_location_id"
  add_index "template_check_records", ["submitter_id"], :name => "index_template_check_records_on_submitter_id"
  add_index "template_check_records", ["template_report_id", "check_point_id"], :name => "template_report_id_and_check_point_id", :unique => true
  add_index "template_check_records", ["template_report_id"], :name => "index_template_check_records_on_template_report_id"
  add_index "template_check_records", ["tenant_id"], :name => "index_template_check_records_on_tenant_id"

  create_table "template_reports", :force => true do |t|
    t.integer  "template_id"
    t.integer  "submitter_id"
    t.integer  "tenant_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "template_reports", ["submitter_id"], :name => "index_template_reports_on_submitter_id"
  add_index "template_reports", ["template_id"], :name => "index_template_reports_on_template_id"
  add_index "template_reports", ["tenant_id"], :name => "index_template_reports_on_tenant_id"

  create_table "templates", :force => true do |t|
    t.string   "name"
    t.string   "desc"
    t.integer  "tenant_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "templates", ["tenant_id"], :name => "index_templates_on_tenant_id"

  create_table "tenants", :force => true do |t|
    t.string   "name"
    t.date     "term"
    t.spatial  "coordinate", :limit => {:srid=>4326, :type=>"point", :geographic=>true}
    t.integer  "zoom",                                                                   :default => 15
    t.datetime "created_at",                                                                                :null => false
    t.datetime "updated_at",                                                                                :null => false
    t.string   "prefix"
    t.boolean  "tile",                                                                   :default => false
  end

  create_table "track_points", :force => true do |t|
    t.float    "radius"
    t.spatial  "coordinate",                                :limit => {:srid=>4326, :type=>"point", :geographic=>true}
    t.string   "coortype"
    t.integer  "tenant_id"
    t.integer  "user_id"
    t.integer  "interval_time_between_generate_and_submit"
    t.datetime "generated_time_of_client_version"
    t.datetime "generated_time_of_server_version"
    t.datetime "created_at",                                                                                            :null => false
    t.datetime "updated_at",                                                                                            :null => false
  end

  add_index "track_points", ["coordinate"], :name => "index_track_points_on_coordinate", :spatial => true
  add_index "track_points", ["generated_time_of_server_version"], :name => "index_track_points_on_generated_time_of_server_version"
  add_index "track_points", ["tenant_id"], :name => "index_track_points_on_tenant_id"
  add_index "track_points", ["user_id"], :name => "index_track_points_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "account"
    t.string   "password_digest"
    t.string   "remember_token"
    t.string   "name"
    t.string   "mobile"
    t.integer  "tenant_id"
    t.integer  "manager_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.integer  "role_id"
  end

  add_index "users", ["remember_token"], :name => "index_users_on_remember_token"
  add_index "users", ["tenant_id"], :name => "index_users_on_tenant_id"

  create_table "videos", :force => true do |t|
    t.string   "video"
    t.integer  "video_attachment_id"
    t.string   "video_attachment_type"
    t.integer  "tenant_id"
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
  end

  add_index "videos", ["tenant_id"], :name => "index_videos_on_tenant_id"
  add_index "videos", ["video_attachment_id"], :name => "index_videos_on_video_attachment_id"

end
