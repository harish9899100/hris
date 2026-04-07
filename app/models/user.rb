class User < ApplicationRecord
  rolify
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  belongs_to :employee, optional: true
  before_create :generate_api_key

  def super_admin!  = add_role(:super_admin)
  def hr_manager!   = add_role(:hr_manager)
  def dept_manager! = add_role(:dept_manager)
  def employee_role! = add_role(:employee)

  def super_admin?  = has_role?(:super_admin)
  def hr_manager?   = has_role?(:hr_manager)
  def dept_manager? = has_role?(:dept_manager)
  def employee_role? = has_role?(:employee)

  def hr_or_above?
    super_admin? || hr_manager?
  end
  
  def manager_or_above?
    super_admin? || hr_manager? || dept_manager?
  end

  def organization
    employee&.organization
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[id name email employee_id created_at updated_at]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[employee]
  end
  private
  def generate_api_key
    self.api_key = SecureRandom.hex(32)
  end
end
