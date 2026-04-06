class AddStatusToAttendanceRecords < ActiveRecord::Migration[8.1]
  def change
    add_column :attendance_records, :status, :integer
  end
end
