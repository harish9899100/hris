class Department < ApplicationRecord
  include TenantScoped
  belongs_to :manager, class_name: 'Employee', optional: true
  has_many :positions, dependent: :destroy
  has_many :employees, dependent: :nullify
  validates :name, presence: true
  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "description", "id", "manager_id", "name", "updated_at"]
  end
end
