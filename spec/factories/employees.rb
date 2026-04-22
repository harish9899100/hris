FactoryBot.define do
  factory :employee do
    first_name { "MyString" }
    last_name { "MyString" }
    email { "MyString" }
    employee_id { "MyString" }
    date_of_joining { "2026-04-20" }
    employment_status { 1 }
    salary { "9.99" }
    phone { "MyString" }
    organization { nil }
    department { nil }
  end
end
