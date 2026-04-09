puts "\nCreating organization..."

org = Organization.find_or_create_by!(slug: "vardara-software") do |o|
  o.name = "Vardara Software"
  o.settings = {
    work_start_time: "10:00",
    late_threshold_minutes: 15,
    working_days: [1, 2, 3, 4, 5],
    attendance_based_deduction: true
  }
end

Current.organization = org

puts "Organization created: #{org.name}"

puts "\nCreating admin user..."

admin_user = AdminUser.find_or_initialize_by(email: "admin@gmail.com")
if admin_user.new_record?
  admin_user.password = "harishkhileri"
  admin_user.password_confirmation = "harishkhileri"
end
admin_user.save!

puts "Admin user created"

puts "\nCreating departments..."

eng_dept = Department.find_or_initialize_by(name: "Engineering", organization: org)
eng_dept.description ||= "Handles software development and technical operations."
eng_dept.save!

hr_dept = Department.find_or_initialize_by(name: "HR", organization: org)
hr_dept.description ||= "Handles recruitment, employee management, and policies."
hr_dept.save!

fin_dept = Department.find_or_initialize_by(name: "Finance", organization: org)
fin_dept.description ||= "Handles payroll, budgeting, and financial reporting."
fin_dept.save!

ops_dept = Department.find_or_initialize_by(name: "Operations", organization: org)
ops_dept.description ||= "Handles internal operations and process execution."
ops_dept.save!

marketing_dept = Department.find_or_initialize_by(name: "Marketing", organization: org)
marketing_dept.description ||= "Handles promotions, campaigns, and branding."
marketing_dept.save!

departments = [eng_dept, hr_dept, fin_dept, ops_dept, marketing_dept]

puts "Departments created: #{departments.count}"

puts "\nCreating positions..."

pos_eng = Position.find_or_initialize_by(title: "Software Engineer", department: eng_dept, organization: org)
pos_eng.employment_type ||= :full_time
pos_eng.base_salary ||= 60000
pos_eng.save!

pos_hr = Position.find_or_initialize_by(title: "HR Manager", department: hr_dept, organization: org)
pos_hr.employment_type ||= :full_time
pos_hr.base_salary ||= 50000
pos_hr.save!

pos_fin = Position.find_or_initialize_by(title: "Finance Analyst", department: fin_dept, organization: org)
pos_fin.employment_type ||= :full_time
pos_fin.base_salary ||= 55000
pos_fin.save!

pos_ops = Position.find_or_initialize_by(title: "Operations Executive", department: ops_dept, organization: org)
pos_ops.employment_type ||= :full_time
pos_ops.base_salary ||= 45000
pos_ops.save!

pos_marketing = Position.find_or_initialize_by(title: "Marketing Specialist", department: marketing_dept, organization: org)
pos_marketing.employment_type ||= :full_time
pos_marketing.base_salary ||= 48000
pos_marketing.save!

positions = [pos_eng, pos_hr, pos_fin, pos_ops, pos_marketing]

puts "Positions created: #{positions.count}"

puts "\nCreating employees..."

emp1 = Employee.find_or_initialize_by(employee_id: "EMP001", organization: org)
emp1.first_name = "Vijay"
emp1.last_name = "Choudhary"
emp1.email = "vijay@vardara.com"
emp1.phone = "9876543210"
emp1.date_of_joining = Date.new(2022, 1, 10)
emp1.department = eng_dept
emp1.position = pos_eng
emp1.salary = 60000
emp1.employment_status ||= :active
emp1.save!

emp2 = Employee.find_or_initialize_by(employee_id: "EMP002", organization: org)
emp2.first_name = "Rohit"
emp2.last_name = "Sharma"
emp2.email = "rohit@vardara.com"
emp2.phone = "9876543211"
emp2.date_of_joining = Date.new(2022, 3, 15)
emp2.department = hr_dept
emp2.position = pos_hr
emp2.salary = 50000
emp2.employment_status ||= :active
emp2.save!

emp3 = Employee.find_or_initialize_by(employee_id: "EMP003", organization: org)
emp3.first_name = "Rahul"
emp3.last_name = "Choudhary"
emp3.email = "rahul@vardara.com"
emp3.phone = "9876543212"
emp3.date_of_joining = Date.new(2023, 6, 1)
emp3.department = fin_dept
emp3.position = pos_fin
emp3.salary = 55000
emp3.employment_status ||= :active
emp3.save!

emp4 = Employee.find_or_initialize_by(employee_id: "EMP004", organization: org)
emp4.first_name = "Anjali"
emp4.last_name = "Mehta"
emp4.email = "anjali@vardara.com"
emp4.phone = "9876543213"
emp4.date_of_joining = Date.new(2023, 2, 20)
emp4.department = ops_dept
emp4.position = pos_ops
emp4.salary = 45000
emp4.employment_status ||= :active
emp4.save!

emp5 = Employee.find_or_initialize_by(employee_id: "EMP005", organization: org)
emp5.first_name = "Priya"
emp5.last_name = "Verma"
emp5.email = "priya@vardara.com"
emp5.phone = "9876543214"
emp5.date_of_joining = Date.new(2023, 8, 10)
emp5.department = marketing_dept
emp5.position = pos_marketing
emp5.salary = 48000
emp5.employment_status ||= :active
emp5.save!

employees = [emp1, emp2, emp3, emp4, emp5]

puts "Employees created: #{employees.count}"

puts "\nAssigning managers..."

eng_dept.update!(manager: emp1)
hr_dept.update!(manager: emp2)
fin_dept.update!(manager: emp3)
ops_dept.update!(manager: emp4)
marketing_dept.update!(manager: emp5)

emp2.update!(manager: emp1)
emp3.update!(manager: emp1)
emp4.update!(manager: emp1)
emp5.update!(manager: emp1)

puts "Managers assigned"

puts "\nCreating user accounts..."

super_admin = User.find_or_initialize_by(email: "superadmin@vardara.com")
super_admin.name = "Super Admin"
super_admin.employee = emp1
super_admin.organization = org if super_admin.respond_to?(:organization=)
if super_admin.new_record?
  super_admin.password = "harishkhileri"
  super_admin.password_confirmation = "harishkhileri"
end
super_admin.save!
super_admin.add_role(:super_admin) unless super_admin.has_role?(:super_admin)

hr_user = User.find_or_initialize_by(email: "hr@vardara.com")
hr_user.name = "HR Manager"
hr_user.employee = emp2
hr_user.organization = org if hr_user.respond_to?(:organization=)
if hr_user.new_record?
  hr_user.password = "harishkhileri"
  hr_user.password_confirmation = "harishkhileri"
end
hr_user.save!
hr_user.add_role(:hr_manager) unless hr_user.has_role?(:hr_manager)

dept_mgr = User.find_or_initialize_by(email: "eng.manager@vardara.com")
dept_mgr.name = "Engineering Manager"
dept_mgr.employee = emp1
dept_mgr.organization = org if dept_mgr.respond_to?(:organization=)
if dept_mgr.new_record?
  dept_mgr.password = "harishkhileri"
  dept_mgr.password_confirmation = "harishkhileri"
end
dept_mgr.save!
dept_mgr.add_role(:dept_manager) unless dept_mgr.has_role?(:dept_manager)

emp_user = User.find_or_initialize_by(email: "employee@vardara.com")
emp_user.name = "Employee User"
emp_user.employee = emp3
emp_user.organization = org if emp_user.respond_to?(:organization=)
if emp_user.new_record?
  emp_user.password = "harishkhileri"
  emp_user.password_confirmation = "harishkhileri"
end
emp_user.save!
emp_user.add_role(:employee) unless emp_user.has_role?(:employee)

puts "Users created"

puts "\nCreating attendance records..."

(30.days.ago.to_date..Date.yesterday).each do |day|
  next if [0, 6].include?(day.wday) 

  employees.each do |emp|
    status = [:present, :present, :present, :absent, :on_leave].sample
    check_in = nil
    check_out = nil

    if status == :present
      check_in = Time.zone.parse("#{day} #{rand(9..10)}:#{rand(0..59).to_s.rjust(2, '0')}")
      check_out = check_in + rand(7..9).hours
    end

    attendance = AttendanceRecord.find_or_initialize_by(
      employee: emp,
      organization: org,
      date: day
    )

    attendance.status = status
    attendance.check_in = check_in
    attendance.check_out = check_out
    attendance.save!
  end
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
  l.approved_by = hr_user if l.respond_to?(:approved_by=)
  l.save!
end

LeaveRequest.find_or_initialize_by(
  employee: emp5,
  organization_id: org.id,
  start_date: Date.today + 12.days,
  end_date: Date.today + 13.days
).tap do |l|
  l.leave_type = "sick"
  l.reason = "Health issue"
  l.status ||= "approved"
  l.approved_by = hr_user if l.respond_to?(:approved_by=)
  l.save!
end

puts "Leave requests created"

puts "\nCreating payslips..."

[
  { employee: emp1, gross: 60000, deductions: 5000, net: 55000 },
  { employee: emp2, gross: 50000, deductions: 4000, net: 46000 },
  { employee: emp3, gross: 55000, deductions: 4500, net: 50500 },
  { employee: emp4, gross: 45000, deductions: 3000, net: 42000 },
  { employee: emp5, gross: 48000, deductions: 3500, net: 44500 }
].each do |data|
  Payslip.find_or_initialize_by(
    employee: data[:employee],
    month: Date.today.month,
    year: Date.today.year
  ).tap do |p|
    p.gross = data[:gross]
    p.deductions = data[:deductions]
    p.net = data[:net]
    p.save!
  end
end

puts "Payslips created"

puts "\n=============================="
puts "Seed completed successfully!"
puts "=============================="
puts "Login credentials:"
puts "Admin Panel     : admin@gmail.com / harishkhileri"
puts "Super Admin     : superadmin@vardara.com / harishkhileri"
puts "HR Manager      : hr@vardara.com / harishkhileri"
puts "Dept Manager    : eng.manager@vardara.com / harishkhileri"
puts "Employee User   : employee@vardara.com / harishkhileri"
puts "=============================="