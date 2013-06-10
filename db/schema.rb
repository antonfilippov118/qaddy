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

ActiveRecord::Schema.define(:version => 20130511181055) do

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

  create_table "campaigns", :force => true do |t|
    t.string   "name"
    t.string   "code"
    t.decimal  "amount"
    t.boolean  "active"
    t.integer  "webstore_id"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
    t.string   "tracking_url_params"
  end

  add_index "campaigns", ["webstore_id"], :name => "index_campaigns_on_webstore_id"

  create_table "default_sharing_texts", :force => true do |t|
    t.string   "text",                          :null => false
    t.integer  "use_counter", :default => 0
    t.boolean  "active",      :default => true
    t.integer  "webstore_id"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  add_index "default_sharing_texts", ["webstore_id"], :name => "index_default_sharing_texts_on_webstore_id"

  create_table "import_job_items", :force => true do |t|
    t.datetime "last_process_date"
    t.text     "last_process_message"
    t.string   "last_process_status"
    t.string   "order_number"
    t.decimal  "order_total"
    t.string   "order_customer_email"
    t.string   "order_customer_name"
    t.datetime "order_send_email_at"
    t.string   "order_item_page_url"
    t.string   "order_item_image_url"
    t.string   "order_item_name"
    t.string   "order_item_description"
    t.decimal  "order_item_total"
    t.integer  "order_item_qty"
    t.integer  "import_job_id"
    t.datetime "created_at",             :null => false
    t.datetime "updated_at",             :null => false
  end

  add_index "import_job_items", ["import_job_id"], :name => "index_import_job_items_on_import_job_id"

  create_table "import_jobs", :force => true do |t|
    t.string   "filename"
    t.boolean  "submitted"
    t.datetime "last_process_date"
    t.text     "last_process_message"
    t.integer  "webstore_id"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
  end

  add_index "import_jobs", ["webstore_id"], :name => "index_import_jobs_on_webstore_id"

  create_table "order_items", :force => true do |t|
    t.string   "page_url",                                  :null => false
    t.string   "image_url",                                 :null => false
    t.string   "name",                                      :null => false
    t.string   "description"
    t.string   "default_sharing_text"
    t.decimal  "total"
    t.integer  "qty"
    t.integer  "order_id",                                  :null => false
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.string   "product_image_file_name"
    t.string   "product_image_content_type"
    t.integer  "product_image_file_size"
    t.datetime "product_image_updated_at"
    t.string   "ref_code"
    t.integer  "share_count",                :default => 0, :null => false
    t.integer  "click_count",                :default => 0, :null => false
    t.string   "short_url_clicked"
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
    t.string   "ref_code"
    t.integer  "email_sent_count",       :default => 0, :null => false
    t.datetime "email_last_sent_at"
    t.integer  "email_read_count",       :default => 0, :null => false
    t.string   "short_url_emailview"
    t.string   "short_url_doshare"
    t.string   "discount_code"
    t.string   "tracking_url_params"
  end

  add_index "orders", ["number", "webstore_id"], :name => "index_orders_on_number_and_webstore_id", :unique => true
  add_index "orders", ["number"], :name => "index_orders_on_number"
  add_index "orders", ["webstore_id"], :name => "index_orders_on_webstore_id"

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "shares", :force => true do |t|
    t.string   "platform"
    t.text     "platform_user"
    t.text     "publish_result"
    t.integer  "order_item_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "shares", ["order_item_id"], :name => "index_shares_on_order_item_id"

  create_table "signup_beta", :force => true do |t|
    t.string   "company"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "url"
    t.string   "ip_address"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

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
    t.datetime "created_at",                                                    :null => false
    t.datetime "updated_at",                                                    :null => false
    t.integer  "default_send_after_hours",                   :default => 120
    t.boolean  "send_email_without_discount",                :default => false
    t.integer  "skip_send_email_for_orders_older_than_days", :default => 60,    :null => false
    t.string   "email_sender_name"
    t.string   "custom_email_subject_with_discount"
    t.text     "custom_email_html_text_with_discount"
    t.string   "custom_email_subject_without_discount"
    t.text     "custom_email_html_text_without_discount"
    t.string   "custom_email_banner_file_name"
    t.string   "custom_email_banner_content_type"
    t.integer  "custom_email_banner_file_size"
    t.datetime "custom_email_banner_updated_at"
    t.text     "custom_email_html_footer"
  end

  add_index "webstores", ["user_id"], :name => "index_webstores_on_user_id"

end
