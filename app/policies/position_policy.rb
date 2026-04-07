class PositionPolicy < ApplicationPolicy
  def index?
    manager_or_above?
  end
  def show?
    manager_or_above?
  end
  def create?
    hr_or_above?
  end
  def new?
    create?
  end
  def update?
    hr_or_above?
  end
  def edit?
    update?
  end
  def destroy?
    super_admin?
  end
  class Scope < ApplicationPolicy::Scope
    def resolve
      hr_or_above? ? scope.all : scope.none
    end
  end
end
