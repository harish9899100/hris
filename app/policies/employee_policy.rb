class EmployeePolicy < ApplicationPolicy
  def index?
    return true if admin_user?

    hr_manager? || dept_manager?
  end

  def show?
    return true if admin_user?

    own_record? || hr_manager? || dept_manager?
  end

  def create?
    return true if admin_user?

    hr_manager?
  end

  def update?
    return true if admin_user?

    hr_manager? || (dept_manager? && manages_record?)
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      return scope.all if user.is_a?(AdminUser)

      if user.hr_manager?
        scope.all
      elsif user.dept_manager?
        scope.where(manager_id: user.employee_id)
      elsif user.employee_role?
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

  def hr_manager?
    user.respond_to?(:hr_manager?) && user.hr_manager?
  end

  def dept_manager?
    user.respond_to?(:dept_manager?) && user.dept_manager?
  end

  def own_record?
    record.id == user.employee_id
  end

  def manages_record?
    record.manager_id == user.employee_id
  end
end