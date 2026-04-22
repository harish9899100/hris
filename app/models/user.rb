class User < ApplicationRecord
  rolify

  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  belongs_to :employee, optional: true

  before_create :generate_api_key

  def hr_manager!
    add_role(:hr_manager)
  end

  def dept_manager!
    add_role(:dept_manager)
  end

  def employee_role!
    add_role(:employee)
  end

  def finance!
    add_role(:finance)
  end


  def hr_manager?
    has_role?(:hr_manager)
  end

  def dept_manager?
    has_role?(:dept_manager)
  end

  def employee_role?
    has_role?(:employee)
  end

  def finance?
    has_role?(:finance)
  end

  def hr_or_above?
    hr_manager?
  end

  def manager_or_above?
    hr_manager? || dept_manager?
  end

  def organization
    employee&.organization
  end

  def self.ransackable_attributes(_auth_object = nil)
    %w[id name email employee_id created_at updated_at]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[employee roles]
  end

  private

  def generate_api_key
    self.api_key ||= SecureRandom.hex(32)
  end
end