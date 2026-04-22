class AttendanceRecordPolicy < ApplicationPolicy
  def show?     = own_record?
  def check_in? = true
  def check_out? = true

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
