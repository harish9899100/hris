module TenantScoped
  extend ActiveSupport::Concern

  included do
    belongs_to :organization

    default_scope do
      Current.organization.present? ? where(organization: Current.organization) : all
    end
  end
end
