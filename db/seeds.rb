puts "=============================="
puts "Starting database seeding..."
puts "=============================="

puts "\nCreating organization..."
org = Organization.find_or_create_by!(slug: "vardara-software") do |o|
  o.name = "Vardara Software"
end
puts "Organization created: #{org.name}"

puts "\nCreating departments..."

eng_dept = Department.find_or_initialize_by(
  name: "Engineering",
  organization: org
)
eng_dept.description ||= "Handles software development and technical operations."
eng_dept.save!

hr_dept = Department.find_or_initialize_by(
  name: "HR",
  organization: org
)
hr_dept.description ||= "Handles recruitment, employee management, and policies."
hr_dept.save!

fin_dept = Department.find_or_initialize_by(
  name: "Finance",
  organization: org
)
fin_dept.description ||= "Handles payroll, budgeting, and financial reporting."
fin_dept.save!

puts "Departments created"

puts "\nCreating positions..."

pos_eng = Position.find_or_initialize_by(
  title: "Software Engineer",
  department: eng_dept,
  organization: org
)
pos_eng.employment_type ||= 0
pos_eng.base_salary ||= 60000
pos_eng.save!

pos_hr = Position.find_or_initialize_by(
  title: "HR Manager",
  department: hr_dept,
  organization: org
)
pos_hr.employment_type ||= 0
pos_hr.base_salary ||= 50000
pos_hr.save!

pos_fin = Position.find_or_initialize_by(
  title: "Finance Analyst",
  department: fin_dept,
  organization: org
)
pos_fin.employment_type ||= 0
pos_fin.base_salary ||= 55000
pos_fin.save!

puts "Positions created"

puts "\nCreating employees..."

emp1 = Employee.find_or_initialize_by(employee_id: "EMP001")
emp1.first_name = "Vijay"
emp1.last_name = "Choudhary"
emp1.email = "vijay@vardara.com"
emp1.phone = "9876543210"
emp1.date_of_joining = Date.new(2022, 1, 10)
emp1.department = eng_dept
emp1.position = pos_eng
emp1.organization = org
emp1.salary = 60000
emp1.employment_status ||= 0
emp1.save!

emp2 = Employee.find_or_initialize_by(employee_id: "EMP002")
emp2.first_name = "Rahul"
emp2.last_name = "Choudhary"
emp2.email = "rahul@vardara.com"
emp2.phone = "9876543211"
emp2.date_of_joining = Date.new(2022, 3, 15)
emp2.department = hr_dept
emp2.position = pos_hr
emp2.organization = org
emp2.salary = 50000
emp2.employment_status ||= 0
emp2.save!

emp3 = Employee.find_or_initialize_by(employee_id: "EMP003")
emp3.first_name = "Rohit"
emp3.last_name = "Sharma"
emp3.email = "rohit@vardara.com"
emp3.phone = "9876543212"
emp3.date_of_joining = Date.new(2023, 6, 1)
emp3.department = fin_dept
emp3.position = pos_fin
emp3.organization = org
emp3.salary = 55000
emp3.employment_status ||= 0
emp3.save!

puts "Employees created"

puts "\nAssigning managers..."

eng_dept.update!(manager: emp1)
hr_dept.update!(manager: emp2)
fin_dept.update!(manager: emp3)

emp2.update!(manager: emp1)
emp3.update!(manager: emp1)

puts "Managers assigned"

puts "\nCreating user accounts..."

super_admin = User.find_or_initialize_by(email: "superadmin@vardara.com")
super_admin.name = "Super Admin"
super_admin.employee = emp1
if super_admin.new_record?
  super_admin.password = "harishkhileri"
  super_admin.password_confirmation = "harishkhileri"
end
super_admin.save!
super_admin.add_role(:super_admin) unless super_admin.has_role?(:super_admin)

hr_user = User.find_or_initialize_by(email: "hr@vardara.com")
hr_user.name = "HR Manager"
hr_user.employee = emp2
if hr_user.new_record?
  hr_user.password = "harishkhileri"
  hr_user.password_confirmation = "harishkhileri"
end
hr_user.save!
hr_user.add_role(:hr_manager) unless hr_user.has_role?(:hr_manager)

dept_mgr = User.find_or_initialize_by(email: "eng.manager@vardara.com")
dept_mgr.name = "Eng Manager"
dept_mgr.employee = emp1
if dept_mgr.new_record?
  dept_mgr.password = "harishkhileri"
  dept_mgr.password_confirmation = "harishkhileri"
end
dept_mgr.save!
dept_mgr.add_role(:dept_manager) unless dept_mgr.has_role?(:dept_manager)

emp_user = User.find_or_initialize_by(email: "employee@vardara.com")
emp_user.name = "Employee"
emp_user.employee = emp3
if emp_user.new_record?
  emp_user.password = "harishkhileri"
  emp_user.password_confirmation = "harishkhileri"
end
emp_user.save!
emp_user.add_role(:employee) unless emp_user.has_role?(:employee)

puts "Created users: superadmin, hr, eng.manager, employee"

puts "\nCreating attendance records..."

AttendanceRecord.find_or_initialize_by(
  employee: emp1,
  organization: org,
  date: Date.today
).tap do |a|
  a.check_in = Time.current.change(hour: 9, min: 0)
  a.check_out = Time.current.change(hour: 18, min: 0)
  a.status ||= 1
  a.save!
end

AttendanceRecord.find_or_initialize_by(
  employee: emp2,
  organization: org,
  date: Date.today
).tap do |a|
  a.check_in = Time.current.change(hour: 9, min: 30)
  a.check_out = Time.current.change(hour: 18, min: 15)
  a.status ||= 1
  a.save!
end

AttendanceRecord.find_or_initialize_by(
  employee: emp3,
  organization: org,
  date: Date.today
).tap do |a|
  a.check_in = Time.current.change(hour: 10, min: 0)
  a.check_out = Time.current.change(hour: 17, min: 45)
  a.status ||= 1
  a.save!
end

puts "Attendance records created"

puts "\nCreating leave requests..."

LeaveRequest.find_or_initialize_by(
  employee: emp3,
  organization_id: org.id,
  start_date: Date.today + 7.days,
  end_date: Date.today + 9.days
).tap do |l|
  l.leave_type = "annual"
  l.reason = "Personal work"
  l.status ||= "pending"
  l.approved_by = hr_user
  l.save!
end

puts "Leave requests created"

puts "\nCreating payslips..."

Payslip.find_or_initialize_by(
  employee: emp1,
  month: Date.today.month,
  year: Date.today.year
).tap do |p|
  p.gross = 60000
  p.deductions = 5000
  p.net = 55000
  p.save!
end

Payslip.find_or_initialize_by(
  employee: emp2,
  month: Date.today.month,
  year: Date.today.year
).tap do |p|
  p.gross = 50000
  p.deductions = 4000
  p.net = 46000
  p.save!
end

Payslip.find_or_initialize_by(
  employee: emp3,
  month: Date.today.month,
  year: Date.today.year
).tap do |p|
  p.gross = 55000
  p.deductions = 4500
  p.net = 50500
  p.save!
end

puts "Payslips created"

puts "\n=============================="
puts "Seed completed successfully!"
puts "=============================="
puts "Login credentials (all passwords: harishkhileri):"
puts "  Super Admin : superadmin@vardara.com"
puts "  HR Manager  : hr@vardara.com"
puts "  Eng Manager : eng.manager@vardara.com"
puts "  Employee    : employee@vardara.com"
puts "=============================="