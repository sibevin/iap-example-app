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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20130827021013) do

  create_table "failed_purchases", force: true do |t|
    t.integer  "user_id"
    t.integer  "sku_id"
    t.string   "store"
    t.text     "receipt"
    t.string   "transaction_val"
    t.string   "pinfo"
    t.string   "dinfo"
    t.string   "error_code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "in_app_purchases", force: true do |t|
    t.integer  "user_id",         null: false
    t.integer  "sku_id",          null: false
    t.string   "store",           null: false
    t.string   "transaction_val", null: false
    t.text     "receipt",         null: false
    t.string   "pinfo",           null: false
    t.string   "dinfo",           null: false
    t.string   "error_code",      null: false
    t.datetime "purchased_at",    null: false
    t.datetime "expires_at"
    t.datetime "cancelled_at"
    t.datetime "refunded_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "in_app_purchases", ["store", "transaction_val"], name: "index_in_app_purchases_on_store_and_transaction_val", using: :btree
  add_index "in_app_purchases", ["user_id"], name: "index_in_app_purchases_on_user_id", using: :btree

  create_table "items", force: true do |t|
    t.string "name"
  end

  create_table "roles", force: true do |t|
    t.string   "name"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "roles", ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id", using: :btree
  add_index "roles", ["name"], name: "index_roles_on_name", using: :btree

  create_table "skus", force: true do |t|
    t.integer  "item_id",                    null: false
    t.string   "name",                       null: false
    t.string   "skucode",                    null: false
    t.integer  "price",                      null: false
    t.integer  "amount",     default: 1,     null: false
    t.boolean  "onshelf",    default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "skus", ["item_id"], name: "index_skus_on_item_id", using: :btree
  add_index "skus", ["skucode"], name: "index_skus_on_skucode", using: :btree

  create_table "store_skucodes", force: true do |t|
    t.integer "sku_id",    null: false
    t.string  "storecode", null: false
    t.string  "skucode",   null: false
  end

  add_index "store_skucodes", ["sku_id"], name: "index_store_skucodes_on_sku_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "users_roles", id: false, force: true do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "users_roles", ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id", using: :btree

end
