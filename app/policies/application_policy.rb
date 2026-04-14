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

  def new?
    create?
  end

  def update?
    false
  end

  def edit?
    update?
  end

  def destroy?
    false
  end

  def super_admin?
    user.present? && user.super_admin?
  end

  def hr_manager?
    user.present? && user.hr_manager?
  end

  def dept_manager?
    user.present? && user.dept_manager?
  end

  def employee_role?
    user.present? && user.employee.present?
  end

  def hr_or_above?
    super_admin? || hr_manager?
  end

  def manager_or_above?
    super_admin? || hr_manager? || dept_manager?
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      if super_admin? || hr_manager?
        scope.all
      elsif dept_manager?
        scope.all
      else
        scope.none
      end
    end

    def super_admin?
      user.present? && user.super_admin?
    end

    def hr_manager?
      user.present? && user.hr_manager?
    end

    def dept_manager?
      user.present? && user.dept_manager?
    end

    def employee_role?
      user.present? && user.employee.present?
    end

    def hr_or_above?
      super_admin? || hr_manager?
    end

    def manager_or_above?
      super_admin? || hr_manager? || dept_manager?
    end
  end
end