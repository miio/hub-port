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

ActiveRecord::Schema.define(:version => 20130123172013) do

  create_table "authentications", :force => true do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.string   "screen_name"
    t.string   "access_token"
    t.string   "access_secret"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "authentications", ["provider", "uid"], :name => "index_authentications_on_provider_and_uid", :unique => true
  add_index "authentications", ["user_id"], :name => "index_authentications_on_user_id"

  create_table "branches", :force => true do |t|
    t.integer  "repo_id"
    t.string   "name"
    t.text     "object"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "branches", ["repo_id"], :name => "index_branches_on_repo_id"

  create_table "issues", :force => true do |t|
    t.integer  "repo_id"
    t.string   "title"
    t.text     "object"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "issues", ["repo_id"], :name => "index_issues_on_repo_id"

  create_table "repos", :force => true do |t|
    t.string   "name"
    t.string   "owner"
    t.text     "object"
    t.text     "work_path"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "user_repo_works", :force => true do |t|
    t.integer  "user_id"
    t.integer  "repo_id"
    t.text     "path"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "user_repo_works", ["repo_id"], :name => "index_user_repo_works_on_repo_id"
  add_index "user_repo_works", ["user_id"], :name => "index_user_repo_works_on_user_id"

  create_table "user_repos", :force => true do |t|
    t.integer  "user_id"
    t.integer  "repo_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "user_repos", ["repo_id"], :name => "index_user_repos_on_repo_id"
  add_index "user_repos", ["user_id"], :name => "index_user_repos_on_user_id"

  create_table "users", :force => true do |t|
    t.integer  "sign_in_count",      :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
  end

end
