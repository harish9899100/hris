class Organization < ApplicationRecord
  has_many :organization_holidays, dependent: :destroy
  has_many :departments, dependent: :destroy
  has_many :positions, dependent: :destroy
  has_many :employees, dependent: :destroy
  has_many :users, dependent: :destroy
  has_many :attendance_records, dependent: :destroy
  has_many :leave_requests, dependent: :destroy
  has_many :payslips, dependent: :destroy
  #has_many :salary_components, dependent: :destroy
  has_many :webhook_subscriptions, dependent: :destroy

  validates :name, presence: true
  validates :slug, presence: true, uniqueness: true

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "name", "slug", "id", "updated_at"]
  end
  def self.ransackable_associations(auth_object = nil)
    [
      "organization_holidays",
      "departments",
      "positions",
      "employees",
      "users",
      "attendance_records",
      "leave_requests",
      "payslips",
      "webhook_subscriptions"
    ]
  end
end