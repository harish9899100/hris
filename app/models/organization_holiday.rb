class OrganizationHoliday < ApplicationRecord
  include TenantScoped

  validates :name, :date, presence: true
  validates :date, uniqueness: { scope: :organization_id, message: "already has a holiday on this date" }
end