class Employee < ApplicationRecord
  include TenantScoped

  belongs_to :organization
  belongs_to :department, optional: true
  belongs_to :position, optional: true
  belongs_to :manager, class_name: "Employee", optional: true

  has_many :subordinates, class_name: "Employee", foreign_key: :manager_id, dependent: :nullify
  has_one :user, dependent: :nullify
  has_many :attendance_records, dependent: :destroy
  has_many :leave_requests, dependent: :destroy
  has_many :payslips, dependent: :destroy
  has_many :salary_components, dependent: :destroy
  has_many_attached :documents

  enum :employment_status, { active: 0, on_leave: 1, terminated: 2 }
  validates :first_name, :last_name, :email, :employee_id, :date_of_joining, presence: true

  validates :email, uniqueness: true
  validates :employee_id, uniqueness: true

  def full_name
    "#{first_name} #{last_name}"
  end

  def today_attendance
    attendance_records.today.first
  end

  def checked_in_today?
    today_attendance&.checked_in? || false
  end

  def checked_out_today?
    today_attendance&.checked_out? || false
  end

  def leave_balance
    annual_used = leave_requests.approved.where(leave_type: "annual").where("start_date >= ?", Date.current.beginning_of_year).to_a.sum(&:duration_days)
    sick_used = leave_requests.approved.where(leave_type: "sick").where("start_date >= ?", Date.current.beginning_of_year).to_a.sum(&:duration_days)
    casual_used = leave_requests.approved.where(leave_type: "casual").where("start_date >= ?", Date.current.beginning_of_year).to_a.sum(&:duration_days)

    {
      annual: [21 - annual_used, 0].max,
      sick:   [10 - sick_used, 0].max,
      casual: [7 - casual_used, 0].max
    }
  end

  def self.ransackable_attributes(_auth_object = nil)
    %w[
      created_at
      date_of_joining
      department_id
      email
      employee_id
      employment_status
      first_name
      id
      last_name
      manager_id
      organization_id
      phone
      position_id
      salary
      updated_at
    ]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[
      department
      organization
      position
      user
      manager
      subordinates
      attendance_records
      leave_requests
    ]
  end
end