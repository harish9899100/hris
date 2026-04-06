# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
#AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password') if Rails.env.development?
puts "Seeding database..."

org = Organization.create!(
  name: "Vardara Software",
  slug: "vardara-software",
  settings: {
    work_start_time: "10:00",
    late_threshold_minutes: 15,
    working_days: [1, 2, 3, 4, 5],
    attendance_based_deduction: true
  }
)
Current.organization = org
puts "Created organization: #{org.name}"

admin_user = AdminUser.create!(email: 'admin@gmail.com', password: 'harishkhileri', password_confirmation: 'harishkhileri')
puts "Created admin user"

dept_names = ['Engineering', 'Design', 'Operations', 'Marketing', 'HR']
departments = dept_names.map do |name|
  org.departments.create!(name: name, description: Faker::Company.catch_phrase)
end
puts "Created #{departments.count} departments"

employment_types = Position.employment_types.keys
positions = departments.flat_map do |dept|
  2.times.map do
    org.positions.create!(
      department: dept,
      title: Faker::Job.title,
      employment_type: employment_types.sample,
      base_salary: rand(30_000..120_000)
    )
  end
end
puts "Created #{positions.count} positions"

employees = 50.times.map do |i|
  dept = departments.sample
  pos  = positions.select { |p| p.department_id == dept.id }.sample || positions.sample

  org.employees.create!(
    first_name: Faker::Name.first_name,
    last_name:  Faker::Name.last_name,
    email:      Faker::Internet.unique.email,
    employee_id: "EMP-#{(i + 1).to_s.rjust(4, '0')}",
    department:  dept,
    position:    pos,
    date_of_joining: Faker::Date.between(from: 3.years.ago, to: Date.today),
    employment_status: :active,
    salary: rand(25_000..100_000),
    phone: Faker::PhoneNumber.phone_number
  )
end
puts "Created #{employees.count} employees"

employees.each_with_index do |emp, i|
  next if i == 0
  manager = employees[0..i-1].select { |e| e.department_id == emp.department_id }.sample
  emp.update!(manager: manager) if manager
end

departments.each do |dept|
  mgr = employees.select { |e| e.department_id == dept.id }.first
  dept.update!(manager: mgr) if mgr
end

puts "Seed complete! #{Employee.count} employees across #{Department.count} departments."