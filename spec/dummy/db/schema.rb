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

ActiveRecord::Schema.define(version: 20170302000001) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "agents", force: :cascade do |t|
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.integer  "browser_id"
    t.boolean  "bot",        default: false, null: false
    t.boolean  "mobile",     default: false, null: false
    t.boolean  "active",     default: true,  null: false
    t.boolean  "locked",     default: false, null: false
    t.boolean  "deleted",    default: false, null: false
    t.string   "name",                       null: false
    t.index ["browser_id"], name: "index_agents_on_browser_id", using: :btree
    t.index ["name"], name: "index_agents_on_name", using: :btree
  end

  create_table "browsers", force: :cascade do |t|
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.boolean  "bot",          default: false, null: false
    t.boolean  "mobile",       default: false, null: false
    t.boolean  "active",       default: true,  null: false
    t.boolean  "locked",       default: false, null: false
    t.boolean  "deleted",      default: false, null: false
    t.integer  "agents_count", default: 0,     null: false
    t.string   "name",                         null: false
  end

  create_table "metric_values", force: :cascade do |t|
    t.integer  "metric_id",             null: false
    t.datetime "time",                  null: false
    t.integer  "quantity",  default: 1, null: false
    t.index "date_trunc('day'::text, \"time\")", name: "metric_values_day_idx", using: :btree
    t.index ["metric_id"], name: "index_metric_values_on_metric_id", using: :btree
  end

  create_table "metrics", force: :cascade do |t|
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
    t.boolean  "incremental",                 default: false, null: false
    t.boolean  "start_with_zero",             default: false, null: false
    t.boolean  "show_on_dashboard",           default: true,  null: false
    t.integer  "default_period",    limit: 2, default: 7,     null: false
    t.integer  "value",                       default: 0,     null: false
    t.integer  "previous_value",              default: 0,     null: false
    t.string   "name",                                        null: false
    t.string   "description",                 default: "",    null: false
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
    t.integer  "agent_id"
    t.inet     "ip"
    t.integer  "inviter_id"
    t.integer  "native_id"
    t.integer  "gender",          limit: 2
    t.integer  "follower_count",            default: 0,     null: false
    t.integer  "followee_count",            default: 0,     null: false
    t.integer  "comments_count",            default: 0,     null: false
    t.integer  "authority",                 default: 0,     null: false
    t.boolean  "super_user",                default: false, null: false
    t.boolean  "deleted",                   default: false, null: false
    t.boolean  "bot",                       default: false, null: false
    t.boolean  "allow_login",               default: true,  null: false
    t.boolean  "email_confirmed",           default: false, null: false
    t.boolean  "phone_confirmed",           default: false, null: false
    t.boolean  "allow_mail",                default: true,  null: false
    t.datetime "last_seen"
    t.date     "birthday"
    t.string   "slug",                                      null: false
    t.string   "screen_name",                               null: false
    t.string   "password_digest"
    t.string   "email"
    t.string   "name"
    t.string   "patronymic"
    t.string   "surname"
    t.string   "phone"
    t.string   "image"
    t.string   "notice"
    t.index ["agent_id"], name: "index_users_on_agent_id", using: :btree
    t.index ["email"], name: "index_users_on_email", using: :btree
    t.index ["screen_name"], name: "index_users_on_screen_name", using: :btree
    t.index ["slug"], name: "index_users_on_slug", unique: true, using: :btree
  end

  add_foreign_key "agents", "browsers"
  add_foreign_key "metric_values", "metrics"
  add_foreign_key "users", "agents"
  add_foreign_key "users", "users", column: "inviter_id", on_update: :cascade, on_delete: :nullify
  add_foreign_key "users", "users", column: "native_id", on_update: :cascade, on_delete: :nullify
end
