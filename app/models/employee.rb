class Employee < ApplicationRecord
  included TenantScoped
  belongs_to :department
  belongs_to :position
  belongs_to :organization
  belongs_to :manager, class_name: 'Employee', optional: true
  has_many :attendance_records, dependent: :destroy
  has_many :leave_requests, dependent: :destroy
  has_many :payslips, dependent: :destroy
  has_many :salary_components, dependent: :destroy
  has_one :user, dependent: :nullify
  has_many_attached :documents
  enum employment_status: { active: 0, on_leave: 1, terminated: 2}
  validates :first_name, :last_name, :email, :employee_id, :date_of_joining, presence: true
  validates :email, uniqueness: true
  validates :employee_id, uniqueness: true
  def full_name
    "#{first_name} #{last_name}"
  end
end
