# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_04_13_014100) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activity_types", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "careers", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "organizations", force: :cascade do |t|
    t.string "name"
    t.text "address"
    t.boolean "current_agreement"
    t.string "contact_name"
    t.string "contact_email"
    t.string "contact_phonenumber"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "people", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "phone_number"
    t.string "id_card"
    t.string "address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "professor_careers", force: :cascade do |t|
    t.bigint "professor_id", null: false
    t.bigint "career_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["career_id"], name: "index_professor_careers_on_career_id"
    t.index ["professor_id"], name: "index_professor_careers_on_professor_id"
  end

  create_table "professors", force: :cascade do |t|
    t.bigint "person_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["person_id"], name: "index_professors_on_person_id"
  end

  create_table "students", force: :cascade do |t|
    t.bigint "person_id", null: false
    t.integer "hours"
    t.boolean "submitted"
    t.date "admission_year"
    t.bigint "career_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["career_id"], name: "index_students_on_career_id"
    t.index ["person_id"], name: "index_students_on_person_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "professor_careers", "careers"
  add_foreign_key "professor_careers", "professors"
  add_foreign_key "professors", "people"
  add_foreign_key "students", "careers"
  add_foreign_key "students", "people"
end
