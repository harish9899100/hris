class Department < ApplicationRecord
  include TenantScoped
  belongs_to :manager, class_name: 'Employee', optional: true
  has_many :positions, dependent: :destroy
  has_many :employees, dependent: :nullify
  belongs_to :organization
  validates :name, presence: true
end
