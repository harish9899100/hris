class AttendanceRecord < ApplicationRecord
  include TenantScoped
  include Ransackable
  belongs_to :employee
  belongs_to :created_by, class_name: 'User', optional: true
  enum :status, { present: 0, absent: 1, half_day: 2, on_leave: 3, incomplete: 4 }
  validates :date, presence: true
  validates :date, uniqueness: { scope: :employee_id, message: "already has an attendance record for this day" }
  validate :check_out_after_check_in
  before_save :auto_set_status
  def hours_worked
    return nil unless check_in && check_out
    ((check_out - check_in) / 3600.0).round(2)
  end
  def late?
    return false unless check_in
    org_settings = employee.organization.settings || {}
    start_time = org_settings["work_start_time"] || "09:00"
    threshold_min = (org_settings["late_threshold_minutes"] || 15).to_i
    scheduled_start = Time.zone.parse("#{date} #{start_time}")
    deadline = scheduled_start + threshold_min.minutes
    check_in > deadline
  end
  def self.today_summary
    today_records = where(date: Date.today)
    {
      present: today_records.present.count,
      absent: today_records.absent.count, 
      on_leave: today_records.on_leave.count,
      incomplete: today_records.incomplete.count,
    }
  end
  def self.monthly_report(employee, year, month)
    start_date = Date.new(year, month, 1)
    end_date   = start_date.end_of_month
    where(employee: employee, date: start_date..end_date).order(:date)
  end

  def self.ransackable_attributes(auth_object = nil)
    ["check_in", "check_out", "created_at", "date", "employee_id", "id", "status", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["employee"]
  end
private

  def check_out_after_check_in
    return unless check_in && check_out
    if check_out <= check_in
      errors.add(:check_out, "must be after clock-in time")
    end
  end

  def auto_set_status
    return if on_leave? || absent?

    if check_in.present? && check_out.nil?
      self.status = :incomplete
    elsif check_in.present? && check_out.present?
      self.status = :present
    end
  end
end
