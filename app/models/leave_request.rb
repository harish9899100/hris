class LeaveRequest < ApplicationRecord
  include TenantScoped
  belongs_to :employee
  belongs_to :approved_by, class_name: 'User', optional: true
  enum :leave_type, { annual: 0, sick: 1, unpaid: 2, other: 3}
  enum :status, {pending: 0, approved: 1, rejected: 2, cancelled: 3}
  validates :start_date, :end_date, :leave_type, presence: true
  validate :end_date_after_start_date
  private
  def end_date_after_start_date
    return unless start_date && end_date
    errors.add(:end_date, "must be after start date ") if end_date < start_date
  end
end
