class AttendanceRecord < ApplicationRecord
  include TenantScoped
  belongs_to :employee
  belongs_to :created_by, class_name: 'User', optional: true
  enum :status, { present: 0, absent: 1, half_day: 2, on_leave: 3, incomplete: 4 }
  validates :date, presence: true
  validates :date, uniqueness: { scope: :employee_id, message: "already has an attendance record for this day" }
  def hours_worked
    return nil unless clock_in_at && clock_out_at
    ((clock_out_at - clock_in_at) / 3600.0).round(2)
  end
end
