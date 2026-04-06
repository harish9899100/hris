class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  belongs_to :employee, optional: true

  def self.ransackable_attributes(auth_object = nil)
    %w[id name email employee_id created_at updated_at]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[employee]
  end
end
