class Employee < ApplicationRecord
  belongs_to :department
  belongs_to :position
  belongs_to :organization
end
