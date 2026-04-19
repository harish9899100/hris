class PayslipPolicy < ApplicationPolicy
  def index?
    employee? || super_admin?
  end

  def show?
    record_belongs_to_current_employee? || super_admin?
  end

  def create?
    super_admin?
  end

  def update?
    super_admin?
  end

  def destroy?
    super_admin?
  end

  class Scope < Scope
    def resolve
      if super_admin?
        scope.all
      elsif employee?
        scope.where(employee_id: user.employee_id)
      else
        scope.none
      end
    end
  end

  private

  def employee?
    user.employee_id.present? && user.employee.present?
  end

  def super_admin?
    user.respond_to?(:role) && user.role == "super_admin"
  end

  def record_belongs_to_current_employee?
    record.employee_id == user.employee_id
  end
end