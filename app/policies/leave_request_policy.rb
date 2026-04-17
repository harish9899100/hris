class LeaveRequestPolicy < ApplicationPolicy
  def index?
    user.role == "super_admin"
  end

  def show?
    user.role == "super_admin"
  end

  def create?
    user.role == "super_admin"
  end

  def update?
    user.role == "super_admin"
  end

  def destroy?
    user.role == "super_admin"
  end

  def review?
    user.role == "super_admin"
  end

  class Scope < Scope
    def resolve
      if user.role == "super_admin"
        scope.all
      else
        scope.none
      end
    end
  end
end