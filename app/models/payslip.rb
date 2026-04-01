class Payslip < ApplicationRecord
  belongs_to :employee
  belongs_to :organization
end
