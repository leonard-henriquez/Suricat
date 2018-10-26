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

ActiveRecord::Schema.define(version: 2018_10_26_110119) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "companies", force: :cascade do |t|
    t.string "name"
    t.integer "structure"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "criteria", force: :cascade do |t|
    t.bigint "user_id"
    t.integer "type"
    t.string "value"
    t.integer "rank"
    t.integer "importance"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_criteria_on_user_id"
  end

  create_table "events", force: :cascade do |t|
    t.bigint "user_id"
    t.date "date"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_events_on_user_id"
  end

  create_table "importances", force: :cascade do |t|
    t.integer "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "job_categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "jobs", force: :cascade do |t|
    t.string "title"
    t.bigint "job_category_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["job_category_id"], name: "index_jobs_on_job_category_id"
  end

  create_table "opportunities", force: :cascade do |t|
    t.bigint "job_id"
    t.bigint "company_id"
    t.bigint "sector_id"
    t.integer "salary"
    t.string "job_description"
    t.integer "contract_type"
    t.string "location"
    t.date "deadline"
    t.date "start_date"
    t.string "url"
    t.date "publishing_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_opportunities_on_company_id"
    t.index ["job_id"], name: "index_opportunities_on_job_id"
    t.index ["sector_id"], name: "index_opportunities_on_sector_id"
  end

  create_table "sector_categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sectors", force: :cascade do |t|
    t.string "name"
    t.bigint "sector_category_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["sector_category_id"], name: "index_sectors_on_sector_category_id"
  end

  create_table "user_opportunities", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "opportunity_id"
    t.integer "automatic_grade"
    t.integer "personnal_grade"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["opportunity_id"], name: "index_user_opportunities_on_opportunity_id"
    t.index ["user_id"], name: "index_user_opportunities_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "criteria", "users"
  add_foreign_key "events", "users"
  add_foreign_key "jobs", "job_categories"
  add_foreign_key "opportunities", "companies"
  add_foreign_key "opportunities", "jobs"
  add_foreign_key "opportunities", "sectors"
  add_foreign_key "sectors", "sector_categories"
  add_foreign_key "user_opportunities", "opportunities"
  add_foreign_key "user_opportunities", "users"
end
