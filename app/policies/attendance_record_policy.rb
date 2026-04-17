class AttendanceRecordPolicy < ApplicationPolicy
  def index?
    manager_or_above?
  end

  def show?
    manager_or_above? || own_employee_record?
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
        dept_employee_ids = Employee.where(department_id: user.employee&.department_id).pluck(:id)
        scope.where(employee_id: dept_employee_ids)
      else
        scope.where(employee_id: user.employee_id)
      end
    end
  end

  private

  def own_employee_record?
    user.employee_id.present? && record.employee_id == user.employee_id
  end
end