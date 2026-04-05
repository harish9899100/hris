module TenantScoped
  extend ActiveSupport::Concern

  included do
    belongs_to :organization

    default_scope do
      if Current.organization.present?
        where(organization: Current.organization)
      else
        none
      end
    end
  end
end