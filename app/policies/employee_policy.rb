class EmployeePolicy < ApplicationPolicy
  def index?
    manager_or_above? || own_record?
  end
  def show?
    manager_or_above? || own_record?
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
      department_id = user.employee&.department_id
      return scope.none unless department_id

      scope.where(department_id: department_id)

    elsif employee_role?
      employee = user.employee
      return scope.none unless employee

      scope.where(id: employee.id)

    else
      scope.none
    end
  end
end
  private
  def own_record?
    record.id == user.employee_id
  end
end