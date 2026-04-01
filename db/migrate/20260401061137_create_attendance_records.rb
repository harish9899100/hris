class CreateAttendanceRecords < ActiveRecord::Migration[8.1]
  def change
    create_table :attendance_records do |t|
      t.references :employee, null: false, foreign_key: true
      t.date :date
      t.datetime :check_in
      t.datetime :check_out
      t.references :organization, null: false, foreign_key: true

      t.timestamps
    end
    add_index :attendance_records, [:employee_id, :date], unique: true
  end
end
