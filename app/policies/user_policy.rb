class UserPolicy < ApplicationPolicy
  def index?
    hr_or_above?
  end

  def show?
    hr_or_above?
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

  class Scope < Scope
    def resolve
      if hr_or_above?
        scope.all
      else
        scope.none
      end
    end
  end
end