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

ActiveRecord::Schema.define(:version => 20130313092401) do

  create_table "durations", :force => true do |t|
    t.integer  "minutes"
    t.integer  "task_id"
    t.integer  "owner_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "partner_id"
  end

  add_index "durations", ["owner_id"], :name => "index_durations_on_owner_id"
  add_index "durations", ["partner_id"], :name => "index_durations_on_partner_id"
  add_index "durations", ["task_id"], :name => "index_durations_on_task_id"

  create_table "tasks", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
    t.string   "status"
    t.integer  "owner_id"
    t.integer  "estimate",    :default => 0
    t.integer  "partner_id"
    t.integer  "scale",       :default => 0
    t.integer  "team_id"
  end

  add_index "tasks", ["owner_id"], :name => "index_tasks_on_owner_id"
  add_index "tasks", ["partner_id"], :name => "index_tasks_on_partner_id"
  add_index "tasks", ["status"], :name => "index_tasks_on_status"
  add_index "tasks", ["team_id"], :name => "index_tasks_on_team_id"

  create_table "teams", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "gravatar"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
