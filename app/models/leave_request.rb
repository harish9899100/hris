class LeaveRequest < ApplicationRecord
  belongs_to :employee
  belongs_to :organization
end
