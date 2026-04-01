class WebhookSubscription < ApplicationRecord
  included TenantScoped
  validates :url, :event, presence: true
  belongs_to :organization
end
