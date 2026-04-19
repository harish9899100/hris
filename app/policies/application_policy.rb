class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    false
  end

  def show?
    false
  end

  def create?
    false
  end

  def update?
    false
  end

  def destroy?
    false
  end

  def employee?
    user&.employee_id.present? && user.employee.present?
  end

  def super_admin?
    user.respond_to?(:role) && user.role == "super_admin"
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      raise NotImplementedError, "You must define #resolve in #{self.class}"
    end

    def employee?
      user&.employee_id.present? && user.employee.present?
    end

    def super_admin?
      user.respond_to?(:role) && user.role == "super_admin"
    end
  end
end