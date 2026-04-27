class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user   = user
    @record = record
  end

  def admin_user?
    user.is_a?(AdminUser)
  end

  def index?
    admin_user?
  end

  def show?
    admin_user?
  end

  def create?
    admin_user?
  end

  def new?
    create?
  end

  def update?
    admin_user?
  end

  def edit?
    update?
  end

  def destroy?
    admin_user?
  end

  def employee?
    return false unless user.respond_to?(:employee_id)
    return false unless user.respond_to?(:employee)

    user.employee_id.present? && user.employee.present?
  end

  def hr?
    user.respond_to?(:role) && user.role == "hr"
  end

  def manager?
    user.respond_to?(:role) && user.role == "manager"
  end

  def dept_manager?
    user.respond_to?(:role) && user.role == "dept_manager"
  end

  def hr_or_above?
    admin_user? || hr?
  end

  def manager_or_above?
    admin_user? || hr? || manager? || dept_manager?
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user  = user
      @scope = scope
    end

    def admin_user?
      user.is_a?(AdminUser)
    end

    def hr?
      user.respond_to?(:role) && user.role == "hr"
    end

    def manager?
      user.respond_to?(:role) && user.role == "manager"
    end

    def dept_manager?
      user.respond_to?(:role) && user.role == "dept_manager"
    end

    def hr_or_above?
      admin_user? || hr?
    end

    def manager_or_above?
      admin_user? || hr? || manager? || dept_manager?
    end

    def employee?
      user.respond_to?(:employee_id) && user.employee_id.present?
    end
    def resolve
      return scope.all if admin_user?

      scope.none
    end
  end
end