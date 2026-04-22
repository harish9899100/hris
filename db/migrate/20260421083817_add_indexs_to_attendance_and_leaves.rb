class AddIndexsToAttendanceAndLeaves < ActiveRecord::Migration[8.1]
  def change
    unless index_exists?(:attendance_records, [:employee_id, :date])
      add_index :attendance_records, [:employee_id, :date], unique: true,
                name: "index_attendance_records_on_employee_id_and_date"
    end

    unless index_exists?(:leave_requests, :employee_id)
      add_index :leave_requests, :employee_id
    end

    unless index_exists?(:leave_requests, :status)
      add_index :leave_requests, :status
    end
  end
end