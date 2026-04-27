class PayslipPolicy < ApplicationPolicy
  def index?
    employee? || hr_manager? || dept_manager?
  end

  def show?
    own_record? || hr_manager? || dept_manager?
  end

  def create?
    hr_manager?
  end

  def update?
    hr_manager?
  end

  def destroy?
    hr_manager?
  end

  class Scope < Scope
    def resolve
      if user.hr_manager?
        scope.all
      elsif user.dept_manager?
        scope.all
      elsif employee?
        scope.where(employee_id: user.employee_id)
      else
        scope.none
      end
    end

    private

    def employee?
      user.employee_id.present? && user.employee.present?
    end
  end

  private

  def employee?
    user.employee_id.present? && user.employee.present?
  end

  def hr_manager?
    user.hr_manager?
  end

  def dept_manager?
    user.dept_manager?
  end

  def own_record?
    record.employee_id == user.employee_id
  end
end