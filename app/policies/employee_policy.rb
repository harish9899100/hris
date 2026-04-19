class EmployeePolicy < ApplicationPolicy
  def index?
    hr_or_above? || dept_manager?
  end

  def show?
    record_belongs_to_current_user? || hr_or_above? || dept_manager?
  end

  def create?
    hr_or_above?
  end

  def update?
    hr_or_above? || (dept_manager? && record_under_current_manager?)
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      if hr_or_above?
        scope.all
      elsif dept_manager?
        scope.where(department_id: user.employee.department_id)
             .or(scope.where(manager_id: user.employee_id))
      elsif employee?
        scope.where(id: user.employee_id)
      else
        scope.none
      end
    end
  end

  private

  def employee?
    user.employee_id.present? && user.employee.present?
  end

  def hr_or_above?
    user.respond_to?(:role) && ["hr", "super_admin"].include?(user.role&.downcase)
  end

  def dept_manager?
    user.employee&.manager_id.present? || user.respond_to?(:role) && user.role == "manager"
  end

  def record_belongs_to_current_user?
    record.id == user.employee_id
  end

  def record_under_current_manager?
    record.manager_id == user.employee_id
  end
end