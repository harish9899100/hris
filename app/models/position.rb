class Position < ApplicationRecord
  included TenantScoped
  belongs_to :department
  has_many :employees, dependent: :nullify
  enum employment_type: { full_time: 0, part_time: 1, contract: 2}
  belongs_to :organization
  validates :title, presence: true
  validates :employment_type, presence: true
end
