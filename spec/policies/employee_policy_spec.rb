require 'rails_helper'

RSpec.describe EmployeePolicy, type: :policy do
  let(:organization) { Organization.create!(name: "Test Org", slug: "test-org", settings: {}) }
  let(:department)   { organization.departments.create!(name: "Engineering") }
  let(:position)     { organization.positions.create!(title: "Dev", department: department, employment_type: :full_time, base_salary: 50000) }

  let(:employee_record) do
    organization.employees.create!(
      first_name: "John",
      last_name: "Doe",
      email: "john#{SecureRandom.hex(4)}@test.com",
      employee_id: "EMP-#{SecureRandom.hex(3)}",
      department: department,
      position: position,
      date_of_joining: Date.today,
      employment_status: :active,
      salary: 50000
    )
  end

  let(:other_employee) do
    organization.employees.create!(
      first_name: "Jane",
      last_name: "Smith",
      email: "jane#{SecureRandom.hex(4)}@test.com",
      employee_id: "EMP-#{SecureRandom.hex(3)}",
      department: department,
      position: position,
      date_of_joining: Date.today,
      employment_status: :active,
      salary: 50000
    )
  end
  
  def make_user(role, emp = employee_record)
    user = User.create!(
      name: "#{role} user",
      email: "#{role}_#{SecureRandom.hex(4)}@test.com",
      password: "password123",
      employee: emp
    )
    user.add_role(role)
    user
  end

  describe "super_admin" do
    let(:user) { make_user(:super_admin) }
    let(:policy) { described_class.new(user, employee_record) }

    it "permits index" do
      expect(policy.index?).to be true
    end

    it "permits show" do
      expect(policy.show?).to be true
    end

    it "permits create" do
      expect(policy.create?).to be true
    end

    it "permits update" do
      expect(policy.update?).to be true
    end

    it "permits destroy" do
      expect(policy.destroy?).to be true
    end
  end

  describe "hr_manager" do
    let(:user) { make_user(:hr_manager) }
    let(:policy) { described_class.new(user, employee_record) }

    it "permits index" do
      expect(policy.index?).to be true
    end

    it "permits show" do
      expect(policy.show?).to be true
    end

    it "permits create" do
      expect(policy.create?).to be true
    end

    it "permits update" do
      expect(policy.update?).to be true
    end

    it "does not permit destroy" do
      expect(policy.destroy?).to be false
    end
  end

  describe "dept_manager" do
    let(:user) { make_user(:dept_manager, employee_record) }
    let(:policy) { described_class.new(user, employee_record) }

    it "permits index" do
      expect(policy.index?).to be true
    end

    it "permits show" do
      expect(policy.show?).to be true
    end

    it "does not permit create" do
      expect(policy.create?).to be false
    end

    it "does not permit update" do
      expect(policy.update?).to be false
    end

    it "does not permit destroy" do
      expect(policy.destroy?).to be false
    end
  end

  describe "employee" do
    let(:user) { make_user(:employee, employee_record) }

    it "permits show for own record" do
      policy = described_class.new(user, employee_record)
      expect(policy.show?).to be true
    end

    it "does not permit show for other employee" do
      policy = described_class.new(user, other_employee)
      expect(policy.show?).to be false
    end

    it "does not permit index" do
      policy = described_class.new(user, employee_record)
      expect(policy.index?).to be false
    end

    it "does not permit create" do
      policy = described_class.new(user, employee_record)
      expect(policy.create?).to be false
    end

    it "does not permit update" do
      policy = described_class.new(user, employee_record)
      expect(policy.update?).to be false
    end

    it "does not permit destroy" do
      policy = described_class.new(user, employee_record)
      expect(policy.destroy?).to be false
    end
  end
end