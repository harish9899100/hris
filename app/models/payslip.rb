class Payslip < ApplicationRecord
  #include TenantScoped

  belongs_to :employee

  has_one_attached :pdf_file

  validates :employee_id, :month, :year, :gross, :deductions, :net, presence: true
  validates :month, inclusion: { in: 1..12 }
  validates :year, numericality: { only_integer: true }
  validates :employee_id, uniqueness: { scope: [:month, :year] }
end