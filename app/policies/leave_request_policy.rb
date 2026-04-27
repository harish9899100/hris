class LeaveRequestPolicy < ApplicationPolicy
  def show?    = own_record?
  def new?     = true
  def create?  = true
  def cancel?  = own_record? && record.can_cancel?

  class Scope < Scope
    def resolve
      scope.where(employee_id: user.employee_id)
    end
  end

  private

  def own_record?
    record.employee_id == user.employee_id
  end
end