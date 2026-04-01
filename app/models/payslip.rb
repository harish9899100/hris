class Payslip < ApplicationRecord
  included TenantScoped
  belongs_to :employee
  belongs_to :processed_by, class_name: 'User', optional: true
  has_one_attached :pdf_file
  enum status: {draft: 0, finalized: 1, paid: 2}
  validates :period_month, presence: true
  validates :period_month, uniqueness: {scope: :employee_id}
end
