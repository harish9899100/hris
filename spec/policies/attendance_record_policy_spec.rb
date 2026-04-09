require 'rails_helper'

RSpec.describe AttendanceRecordPolicy, type: :policy do
  let(:organization) { Organization.create!(name: "Test Org", slug: "test-org-att", settings: {}) }
  let(:department)   { organization.departments.create!(name: "Engineering") }
  let(:position)     { organization.positions.create!(title: "Dev", department: department, employment_type: :full_time, base_salary: 50000) }

  let(:employee) do
    organization.employees.create!(
      first_name: "Ali",
      last_name: "Khan",
      email: "ali#{SecureRandom.hex(4)}@test.com",
      employee_id: "EMP-#{SecureRandom.hex(3)}",
      department: department,
      position: position,
      date_of_joining: Date.today,
      employment_status: :active,
      salary: 40000
    )
  end

  let(:attendance_record) do
    organization.attendance_records.create!(
      employee: employee,
      date: Date.today,
      status: :present
    )
  end

  def make_user(role, emp = employee)
    user = User.create!(
      name: "#{role} user",
      email: "#{role}_#{SecureRandom.hex(4)}@test.com",
      password: "password123",
      employee: emp
    )
    user.add_role(role)
    user
  end

  describe "hr_manager" do
    let(:user) { make_user(:hr_manager) }
    let(:policy) { described_class.new(user, attendance_record) }

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
  end

  describe "dept_manager" do
    let(:user) { make_user(:dept_manager, employee) }
    let(:policy) { described_class.new(user, attendance_record) }

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

  describe "regular employee" do
    let(:user) { make_user(:employee, employee) }
    let(:policy) { described_class.new(user, attendance_record) }

    it "permits show for own attendance" do
      expect(policy.show?).to be true
    end

    it "does not permit index" do
      expect(policy.index?).to be false
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
end