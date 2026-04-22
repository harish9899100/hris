class AttendanceRecord < ApplicationRecord
  include TenantScoped
  include Ransackable

  belongs_to :employee
  belongs_to :organization
  belongs_to :created_by, class_name: "User", optional: true

  enum :status, { present: 0, absent: 1, half_day: 2, on_leave: 3, incomplete: 4, late: 5 }

  validates :date, presence: true

  validates :employee_id, uniqueness: { scope: :date, message: "already has an attendance record for this date" }

  validate :check_out_after_check_in

  before_save :auto_set_status

  scope :today, -> { where(date: Date.current) }

  scope :recent, -> { order(date: :desc) }

  scope :for_month, lambda { |year, month|
    start_date = Date.new(year, month, 1)
    end_date   = start_date.end_of_month
    where(date: start_date..end_date)
  }

  def checked_in?
    check_in.present?
  end

  def checked_out?
    check_out.present?
  end

  def hours_worked
    return nil unless checked_in? && checked_out?

    ((check_out - check_in) / 3600.0).round(2)
  end

  def duration
    hours_worked
  end

  def duration_formatted
    return "—" unless duration

    hours = duration.floor
    minutes = ((duration - hours) * 60).round

    "#{hours}h #{minutes}m"
  end

  def late?
    return false unless check_in.present?

    org_settings = employee.organization.settings || {}

    start_time = org_settings["work_start_time"] || "09:00"
    threshold  = (org_settings["late_threshold_minutes"] || 15).to_i

    scheduled_start = Time.zone.parse("#{date} #{start_time}")
    deadline = scheduled_start + threshold.minutes

    check_in > deadline
  end

  def self.today_summary
    records = today

    {
      present: records.present.count,
      absent: records.absent.count,
      on_leave: records.on_leave.count,
      incomplete: records.incomplete.count,
      late: records.late.count
    }
  end

  def self.monthly_report(employee, year, month)
    for_month(year, month).where(employee: employee).order(:date)
  end

  def self.check_in_today!(employee)
    record = find_or_initialize_by(
      employee_id: employee.id,
      date: Date.current
    )

    raise "Already checked in today" if record.persisted? && record.checked_in?

    record.assign_attributes(
      check_in: Time.current,
      organization_id: employee.organization_id,
      status: :present
    )

    record.save!
    record
  end

  def self.check_out_today!(employee)
    record = today.find_by(employee_id: employee.id)

    raise "No check-in found for today" unless record&.checked_in?
    raise "Already checked out today" if record.checked_out?

    record.update!(check_out: Time.current)
    record
  end


  def self.ransackable_attributes(_auth_object = nil)
    %w[
      check_in
      check_out
      created_at
      date
      employee_id
      id
      organization_id
      status
      updated_at
    ]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[employee organization]
  end

  private

  def check_out_after_check_in
    return unless check_in.present? && check_out.present?

    if check_out <= check_in
      errors.add(:check_out, "must be after check-in time")
    end
  end

  def auto_set_status
    return if on_leave? || absent? || half_day?

    if checked_in? && !checked_out?
      self.status = :incomplete

    elsif checked_in? && checked_out?
      self.status = late? ? :late : :present
    end
  end
end
