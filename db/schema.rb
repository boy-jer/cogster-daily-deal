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

ActiveRecord::Schema.define(:version => 20110825230408) do

  create_table "addresses", :force => true do |t|
    t.string   "line_1"
    t.string   "line_2"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "phone"
    t.string   "country"
    t.integer  "addressable_id"
    t.string   "addressable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "business_options", :force => true do |t|
    t.string "category"
  end

  create_table "businesses", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "community_id"
    t.integer  "merchant_id"
    t.integer  "business_option_id", :limit => 255
    t.boolean  "active"
    t.boolean  "featured",                          :default => false
    t.string   "image"
    t.string   "email"
  end

  create_table "communities", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "handle"
    t.string   "state"
    t.boolean  "active"
    t.string   "description"
    t.integer  "impact",                :default => 0
    t.date     "event_start_date"
    t.date     "event_completion_date"
    t.date     "redemption_start"
    t.string   "image"
  end

  create_table "community_requests", :force => true do |t|
    t.string   "email"
    t.string   "zip_code"
    t.string   "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "coupons", :force => true do |t|
    t.date     "start_date"
    t.date     "expiration_date"
    t.integer  "amount"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "purchase_id"
    t.boolean  "used"
  end

  create_table "hours", :force => true do |t|
    t.integer  "business_id"
    t.integer  "open_hour"
    t.integer  "open_minute"
    t.string   "open_meridian"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "close_hour"
    t.integer  "close_minute"
    t.string   "close_meridian"
    t.integer  "day"
    t.boolean  "closed"
  end

  create_table "paypal_responses", :force => true do |t|
    t.integer  "purchase_id"
    t.integer  "user_id"
    t.integer  "project_id"
    t.string   "action"
    t.integer  "amount"
    t.boolean  "success"
    t.string   "authorization"
    t.string   "message"
    t.text     "params"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "project_options", :force => true do |t|
    t.string  "description"
    t.boolean "active"
    t.text    "redemption_schedule", :limit => 255
  end

  create_table "projects", :force => true do |t|
    t.integer  "business_id"
    t.string   "name"
    t.decimal  "amount"
    t.integer  "goal",                             :default => 0
    t.date     "success_date"
    t.text     "reason",            :limit => 255
    t.boolean  "active"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "project_option_id"
    t.integer  "funded",                           :default => 0
  end

  create_table "purchases", :force => true do |t|
    t.integer  "user_id"
    t.integer  "project_id"
    t.integer  "amount"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "customer_ip"
    t.string   "error_message"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                               :default => "", :null => false
    t.string   "encrypted_password",   :limit => 128, :default => "", :null => false
    t.string   "password_salt",                       :default => "", :null => false
    t.string   "reset_password_token"
    t.string   "remember_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                       :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "gender",               :limit => 1
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "role"
    t.integer  "community_id"
    t.string   "cogster_id"
    t.integer  "earnings",                            :default => 0
  end

  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "websites", :force => true do |t|
    t.integer  "business_id"
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
