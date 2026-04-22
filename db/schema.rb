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

ActiveRecord::Schema[8.1].define(version: 2026_04_22_112859) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.bigint "author_id"
    t.string "author_type"
    t.text "body"
    t.datetime "created_at", null: false
    t.string "namespace"
    t.bigint "resource_id"
    t.string "resource_type"
    t.datetime "updated_at", null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource"
  end

  create_table "admin_users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.integer "role", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "attendance_records", force: :cascade do |t|
    t.datetime "check_in"
    t.datetime "check_out"
    t.datetime "created_at", null: false
    t.date "date"
    t.bigint "employee_id", null: false
    t.bigint "organization_id", null: false
    t.integer "status"
    t.datetime "updated_at", null: false
    t.index ["employee_id", "date"], name: "index_attendance_records_on_employee_id_and_date", unique: true
    t.index ["employee_id"], name: "index_attendance_records_on_employee_id"
    t.index ["organization_id"], name: "index_attendance_records_on_organization_id"
  end

  create_table "departments", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.bigint "manager_id"
    t.string "name"
    t.bigint "organization_id", null: false
    t.datetime "updated_at", null: false
    t.index ["manager_id"], name: "index_departments_on_manager_id"
    t.index ["organization_id", "name"], name: "index_departments_on_organization_id_and_name", unique: true
    t.index ["organization_id"], name: "index_departments_on_organization_id"
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
    t.bigint "organization_id", null: false
    t.string "phone"
    t.bigint "position_id", null: false
    t.decimal "salary"
    t.datetime "updated_at", null: false
    t.index ["department_id"], name: "index_employees_on_department_id"
    t.index ["email"], name: "index_employees_on_email", unique: true
    t.index ["employee_id"], name: "index_employees_on_employee_id", unique: true
    t.index ["employment_status"], name: "index_employees_on_employment_status"
    t.index ["organization_id"], name: "index_employees_on_organization_id"
    t.index ["position_id"], name: "index_employees_on_position_id"
  end

  create_table "leave_requests", force: :cascade do |t|
    t.bigint "approved_by_id"
    t.datetime "created_at", null: false
    t.bigint "employee_id", null: false
    t.date "end_date"
    t.string "leave_type"
    t.bigint "organization_id"
    t.text "reason"
    t.date "start_date"
    t.integer "status"
    t.datetime "updated_at", null: false
    t.index ["approved_by_id"], name: "index_leave_requests_on_approved_by_id"
    t.index ["employee_id"], name: "index_leave_requests_on_employee_id"
    t.index ["organization_id"], name: "index_leave_requests_on_organization_id"
    t.index ["status"], name: "index_leave_requests_on_status"
  end

  create_table "organization_holidays", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.date "date", null: false
    t.string "name", null: false
    t.bigint "organization_id", null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id", "date"], name: "index_organization_holidays_on_organization_id_and_date", unique: true
    t.index ["organization_id"], name: "index_organization_holidays_on_organization_id"
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
    t.bigint "organization_id", null: false
    t.string "title"
    t.datetime "updated_at", null: false
    t.index ["department_id", "title"], name: "index_positions_on_department_id_and_title", unique: true
    t.index ["department_id"], name: "index_positions_on_department_id"
    t.index ["organization_id"], name: "index_positions_on_organization_id"
  end

  create_table "roles", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.bigint "resource_id"
    t.string "resource_type"
    t.datetime "updated_at", null: false
    t.index ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id"
    t.index ["name"], name: "index_roles_on_name"
    t.index ["resource_type", "resource_id"], name: "index_roles_on_resource"
  end

  create_table "users", force: :cascade do |t|
    t.string "api_key"
    t.datetime "created_at", null: false
    t.string "email"
    t.bigint "employee_id", null: false
    t.string "encrypted_password", null: false
    t.string "name", null: false
    t.datetime "remember_created_at"
    t.datetime "updated_at", null: false
    t.index ["api_key"], name: "index_users_on_api_key", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["employee_id"], name: "index_users_on_employee_id"
  end

  create_table "users_roles", id: false, force: :cascade do |t|
    t.bigint "role_id"
    t.bigint "user_id"
    t.index ["role_id"], name: "index_users_roles_on_role_id"
    t.index ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id"
    t.index ["user_id"], name: "index_users_roles_on_user_id"
  end

  create_table "webhook_subscriptions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "event"
    t.datetime "updated_at", null: false
    t.string "url"
  end

  add_foreign_key "attendance_records", "organizations"
  add_foreign_key "departments", "organizations"
  add_foreign_key "employees", "departments"
  add_foreign_key "employees", "organizations"
  add_foreign_key "employees", "positions"
  add_foreign_key "leave_requests", "organizations"
  add_foreign_key "leave_requests", "users", column: "approved_by_id"
  add_foreign_key "organization_holidays", "organizations"
  add_foreign_key "positions", "departments"
  add_foreign_key "positions", "organizations"
end
