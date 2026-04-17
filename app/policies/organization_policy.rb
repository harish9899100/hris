class OrganizationPolicy < ApplicationPolicy
  def index?
    user&.role == "super_admin"
  end

  class Scope < Scope
    def resolve
      user&.role == "super_admin" ? scope.all : scope.none
    end
  end
end