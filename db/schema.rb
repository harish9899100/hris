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

ActiveRecord::Schema[8.1].define(version: 2026_04_01_165020) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "attendance_records", force: :cascade do |t|
    t.datetime "check_in"
    t.datetime "check_out"
    t.datetime "created_at", null: false
    t.date "date"
    t.bigint "employee_id", null: false
    t.datetime "updated_at", null: false
    t.index ["employee_id", "date"], name: "index_attendance_records_on_employee_id_and_date", unique: true
    t.index ["employee_id"], name: "index_attendance_records_on_employee_id"
  end

  create_table "departments", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.bigint "manager_id"
    t.string "name"
    t.datetime "updated_at", null: false
    t.index ["manager_id"], name: "index_departments_on_manager_id"
    t.index ["name"], name: "index_departments_on_name", unique: true
  end

  create_table "employees", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.date "date_of_joining"
    t.bigint "department_id", null: false
    t.string "email"
    t.string "employee_id"
    t.integer "employment_status"
    t.string "first_name"
    t.string "last_name"
    t.bigint "manager_id"
    t.string "phone"
    t.bigint "position_id", null: false
    t.decimal "salary"
    t.datetime "updated_at", null: false
    t.index ["department_id"], name: "index_employees_on_department_id"
    t.index ["email"], name: "index_employees_on_email", unique: true
    t.index ["employee_id"], name: "index_employees_on_employee_id", unique: true
    t.index ["manager_id"], name: "index_employees_on_manager_id"
    t.index ["position_id"], name: "index_employees_on_position_id"
  end

  create_table "leave_requests", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "employee_id", null: false
    t.date "end_date"
    t.string "leave_type"
    t.text "reason"
    t.date "start_date"
    t.integer "status"
    t.datetime "updated_at", null: false
    t.index ["employee_id"], name: "index_leave_requests_on_employee_id"
  end

  create_table "organizations", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.jsonb "settings", default: {}
    t.string "slug", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_organizations_on_slug", unique: true
  end

  create_table "payslips", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.decimal "deductions"
    t.bigint "employee_id", null: false
    t.decimal "gross"
    t.integer "month"
    t.decimal "net"
    t.datetime "updated_at", null: false
    t.integer "year"
    t.index ["employee_id", "month", "year"], name: "index_payslips_on_employee_id_and_month_and_year", unique: true
    t.index ["employee_id"], name: "index_payslips_on_employee_id"
  end

  create_table "positions", force: :cascade do |t|
    t.decimal "base_salary"
    t.datetime "created_at", null: false
    t.bigint "department_id", null: false
    t.integer "employment_type"
    t.string "title"
    t.datetime "updated_at", null: false
    t.index ["department_id", "title"], name: "index_positions_on_department_id_and_title", unique: true
    t.index ["department_id"], name: "index_positions_on_department_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "api_key"
    t.datetime "created_at", null: false
    t.string "email"
    t.bigint "employee_id", null: false
    t.string "encrypted_password", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["api_key"], name: "index_users_on_api_key", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["employee_id"], name: "index_users_on_employee_id"
  end

  create_table "webhook_subscriptions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "event"
    t.datetime "updated_at", null: false
    t.string "url"
  end

  add_foreign_key "attendance_records", "employees"
  add_foreign_key "departments", "employees", column: "manager_id"
  add_foreign_key "employees", "departments"
  add_foreign_key "employees", "employees", column: "manager_id"
  add_foreign_key "employees", "positions"
  add_foreign_key "leave_requests", "employees"
  add_foreign_key "payslips", "employees"
  add_foreign_key "positions", "departments"
  add_foreign_key "users", "employees"
end
