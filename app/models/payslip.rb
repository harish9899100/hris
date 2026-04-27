class Payslip < ApplicationRecord
  #include TenantScoped

  belongs_to :employee

  has_one_attached :pdf_file

  validates :employee_id, :month, :year, :gross, :deductions, :net, presence: true
  validates :month, inclusion: { in: 1..12 }
  validates :year, numericality: { only_integer: true }
  validates :employee_id, uniqueness: { scope: [:month, :year] }
  def self.ransackable_attributes(auth_object = nil)
    %w[id employee_id month year gross deductions net created_at updated_at]
  end

  def self.ransackable_associations(auth_object = nil)
    ["employee", "pdf_file_attachment", "pdf_file_blob"]
  end
end