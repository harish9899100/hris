class WebhookSubscription < ApplicationRecord
  include TenantScoped
  validates :url, :event, presence: true
end
