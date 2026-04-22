class LeaveRequest < ApplicationRecord
  include TenantScoped
  include Ransackable

  belongs_to :employee
  belongs_to :organization
  belongs_to :approved_by, class_name: "User", optional: true
  enum :status, { pending: 0, approved: 1, rejected: 2, cancelled: 3 }
  LEAVE_TYPES = %w[
    casual
    sick
    annual
    unpaid
    other
  ].freeze

  validates :start_date, :end_date, :leave_type, :reason, presence: true
  validates :leave_type, inclusion: { in: LEAVE_TYPES }
  validates :reason, length: { minimum: 10 }
  validate :end_date_after_start_date
  validate :no_overlapping_leave, on: :create
  scope :pending, -> { where(status: :pending) }
  scope :approved, -> { where(status: :approved) }
  scope :recent, -> { order(created_at: :desc) }

  def duration_days
    return 0 unless start_date && end_date

    (end_date - start_date).to_i + 1
  end

  def can_cancel?
    pending? && start_date > Date.current
  end

  def self.ransackable_attributes(_auth_object = nil)
    %w[
      approved_by_id
      created_at
      employee_id
      end_date
      id
      leave_type
      reason
      start_date
      status
      updated_at
      organization_id
    ]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[
      employee
      approved_by
      organization
    ]
  end

  private

  def end_date_after_start_date
    return unless start_date && end_date

    if end_date < start_date
      errors.add(:end_date, "must be on or after start date")
    end
  end

  def no_overlapping_leave
    return unless start_date && end_date && employee_id

    overlap = LeaveRequest.where(employee_id: employee_id).where.not(status: [:rejected, :cancelled]).where("start_date <= ? AND end_date >= ?", end_date, start_date).exists?

    if overlap
      errors.add(:base, "You already have a leave request overlapping these dates")
    end
  end
end