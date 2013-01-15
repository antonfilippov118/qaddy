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

ActiveRecord::Schema.define(:version => 20130115011651) do

  create_table "active_admin_comments", :force => true do |t|
    t.string   "resource_id",   :null => false
    t.string   "resource_type", :null => false
    t.integer  "author_id"
    t.string   "author_type"
    t.text     "body"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "namespace"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], :name => "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], :name => "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], :name => "index_admin_notes_on_resource_type_and_resource_id"

  create_table "api_keys", :force => true do |t|
    t.string   "key",                          :null => false
    t.boolean  "enabled",    :default => true
    t.integer  "user_id",                      :null => false
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
  end

  add_index "api_keys", ["user_id"], :name => "index_api_keys_on_user_id"

  create_table "order_items", :force => true do |t|
    t.string   "page_url",             :null => false
    t.string   "image_url",            :null => false
    t.string   "name",                 :null => false
    t.string   "description"
    t.string   "default_sharing_text"
    t.decimal  "total"
    t.integer  "qty"
    t.integer  "order_id",             :null => false
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
  end

  add_index "order_items", ["order_id"], :name => "index_order_items_on_order_id"

  create_table "orders", :force => true do |t|
    t.string   "number",                                :null => false
    t.decimal  "total",                                 :null => false
    t.string   "customer_email",                        :null => false
    t.string   "customer_name",                         :null => false
    t.integer  "send_email_after_hours"
    t.datetime "send_email_at"
    t.integer  "discount_code_perc",     :default => 0
    t.integer  "webstore_id",                           :null => false
    t.datetime "created_at",                            :null => false
    t.datetime "updated_at",                            :null => false
    t.text     "internal_comment"
  end

  add_index "orders", ["number", "webstore_id"], :name => "index_orders_on_number_and_webstore_id", :unique => true
  add_index "orders", ["number"], :name => "index_orders_on_number"
  add_index "orders", ["webstore_id"], :name => "index_orders_on_webstore_id"

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.string   "password_digest"
    t.string   "remember_token"
    t.boolean  "admin",                  :default => false
    t.string   "password_reset_token"
    t.datetime "password_reset_sent_at"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["remember_token"], :name => "index_users_on_remember_token"

  create_table "webstores", :force => true do |t|
    t.string   "name"
    t.string   "url"
    t.text     "description"
    t.integer  "user_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "webstores", ["user_id"], :name => "index_webstores_on_user_id"

end
