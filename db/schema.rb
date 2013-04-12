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

ActiveRecord::Schema.define(:version => 20130401130901) do

  create_table "images", :force => true do |t|
    t.string   "image"
    t.integer  "image_attachment_id"
    t.string   "image_attachment_type"
    t.integer  "tenant_id"
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
  end

  add_index "images", ["image_attachment_id"], :name => "index_images_on_image_attachment_id"
  add_index "images", ["tenant_id"], :name => "index_images_on_tenant_id"

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
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
  end

  add_index "issues", ["deadline"], :name => "index_issues_on_deadline"
  add_index "issues", ["issuable_id"], :name => "index_issues_on_issuable_id"
  add_index "issues", ["responsible_person_id"], :name => "index_issues_on_responsible_person_id"
  add_index "issues", ["submitter_id"], :name => "index_issues_on_submitter_id"
  add_index "issues", ["tenant_id"], :name => "index_issues_on_tenant_id"

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

  create_table "tenants", :force => true do |t|
    t.string   "name"
    t.date     "term"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

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
