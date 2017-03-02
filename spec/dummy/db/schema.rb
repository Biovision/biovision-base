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

ActiveRecord::Schema.define(version: 20170301000002) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

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

  add_foreign_key "metric_values", "metrics"
end
