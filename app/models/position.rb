class Position < ApplicationRecord
  include TenantScoped

  belongs_to :department
  has_many :employees, dependent: :nullify

  enum :employment_type, { full_time: 0, part_time: 1, contract: 2 }

  validates :title, presence: true
  validates :employment_type, presence: true

  def self.ransackable_attributes(auth_object = nil)
    ["base_salary", "created_at", "department_id", "employment_type", "id", "title", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["department", "employees", "organization"]
  end
end