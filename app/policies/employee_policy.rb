class EmployeePolicy < ApplicationPolicy
  def index?
    return true if admin_user?

    hr_or_above? || dept_manager?
  end

  def show?
    return true if admin_user?

    record_belongs_to_current_user? || hr_or_above? || dept_manager?
  end

  def create?
    return true if admin_user?

    hr_or_above?
  end

  def update?
    return true if admin_user?

    hr_or_above? || (dept_manager? && record_under_current_manager?)
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      return scope.all if user.is_a?(AdminUser)

      if hr_or_above?
        scope.all
      elsif dept_manager? && user.respond_to?(:employee) && user.employee.present?
        scope.where(department_id: user.employee.department_id)
             .or(scope.where(manager_id: user.employee_id))
      elsif employee? && user.respond_to?(:employee_id)
        scope.where(id: user.employee_id)
      else
        scope.none
      end
    end
  end

  private

  def admin_user?
    user.is_a?(AdminUser)
  end

  def employee?
    return false unless user.respond_to?(:employee_id)
    return false unless user.respond_to?(:employee)

    user.employee_id.present? && user.employee.present?
  end

  def hr_or_above?
    return false unless user.respond_to?(:role)

    %w[hr admin super_admin].include?(user.role.to_s.downcase)
  end

  def dept_manager?
    return false if admin_user?

    (user.respond_to?(:role) && user.role == "manager") ||
      (user.respond_to?(:employee) &&
       user.employee.present? &&
       user.employee.manager_id.present?)
  end

  def record_belongs_to_current_user?
    return false unless user.respond_to?(:employee_id)

    record.id == user.employee_id
  end

  def record_under_current_manager?
    return false unless user.respond_to?(:employee_id)

    record.manager_id == user.employee_id
  end
end