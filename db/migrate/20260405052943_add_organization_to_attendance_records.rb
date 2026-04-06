class AddOrganizationToAttendanceRecords < ActiveRecord::Migration[8.1]
  def change
    add_reference :attendance_records, :organization, null: false, foreign_key: true
  end
end
