class DepartmentPolicy < ApplicationPolicy
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
      if hr_or_above?
        scope.all
      elsif dept_manager?
        scope.where(id: user.employee&.department_id)
      else
        scope.none
      end
    end
  end
end