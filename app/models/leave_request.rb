class LeaveRequest < ApplicationRecord
  include TenantScoped
  include Ransackable
  belongs_to :employee
  belongs_to :approved_by, class_name: 'User', optional: true
  enum :status, {pending: 0, approved: 1, rejected: 2, cancelled: 3}
  LEAVE_TYPES = %w[annual sick unpaid other].freeze
  validates :start_date, :end_date, :leave_type, presence: true
  validates :leave_type, inclusion: { in: %w[casual sick annual unpaid other] }
  validate :end_date_after_start_date

    def self.ransackable_attributes(auth_object = nil)
    [
      "created_at", "employee_id", "approved_by_id", "start_date", "end_date", "leave_type", "status", "reason", "id", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["employee", "approved_by"]
  end
  private
  def end_date_after_start_date
    return unless start_date && end_date
    errors.add(:end_date, "must be after start date ") if end_date < start_date
  end
end
