module TenantScoped
  extend ActiveSupport::Concern

  included do
    belongs_to :organization
    default_scope { where(organization: Current.organization) if Current.organization.present? }
  end
end