# frozen_string_literal: true
# ActiveAdmin.register_page "Dashboard" do
#   menu priority: 1, label: proc { I18n.t("active_admin.dashboard") }

#   content title: proc { I18n.t("active_admin.dashboard") } do
#     div class: "blank_slate_container", id: "dashboard_default_message" do
#       span class: "blank_slate" do
#         span I18n.t("active_admin.dashboard_welcome.welcome")
#         small I18n.t("active_admin.dashboard_welcome.call_to_action")
#       end
#     end

    # Here is an example of a simple dashboard with columns and panels.
    #
    # columns do
    #   column do
    #     panel "Recent Posts" do
    #       ul do
    #         Post.recent(5).map do |post|
    #           li link_to(post.title, admin_post_path(post))
    #         end
    #       end
    #     end
    #   end

    #   column do
    #     panel "Info" do
    #       para "Welcome to ActiveAdmin."
    #     end
    #   end
    # end
#   end # content
# end

ActiveAdmin.register_page "Dashboard" do
  menu priority: 1, label: proc { I18n.t("active_admin.dashboard") }

  content title: proc { I18n.t("active_admin.dashboard") } do

    columns do
      column do
        panel "Headcount" do
          div class: "dashboard-stat" do
            h2 Employee.where(employment_status: :active).count
            para "Active Employees"
          end
        end
      end

      column do
        panel "Departments" do
          div class: "dashboard-stat" do
            h2 Department.count
            para "Total Departments"
          end
        end
      end

      column do
        panel "Pending Leaves" do
          div class: "dashboard-stat" do
            h2 LeaveRequest.where(status: :pending).count
            para "Awaiting Approval"
          end
        end
      end

      column do
        panel "Today's Attendance" do
          div class: "dashboard-stat" do
            h2 AttendanceRecord.where(date: Date.today, status: :present).count
            para "Present Today"
          end
        end
      end
    end

    columns do
      column do
        panel "Recently Joined Employees" do
          table_for Employee.order(date_of_joining: :desc).limit(8) do
            column("Name")       { |e| link_to e.full_name, admin_employee_path(e) }
            column("Department") { |e| e.department.name }
            column("Position")   { |e| e.position.title }
            column("Joined")     { |e| e.date_of_joining.strftime("%d %b %Y") }
            column("Status")     { |e| status_tag e.employment_status }
          end
        end
      end

      column do
        panel "Pending Leave Requests" do
          table_for LeaveRequest.where(status: :pending).order(created_at: :desc).limit(8) do
            column("Employee")   { |l| link_to l.employee.full_name, admin_leave_request_path(l) }
            column("Type")       { |l| l.leave_type.humanize }
            column("From")       { |l| l.start_date.strftime("%d %b") }
            column("To")         { |l| l.end_date.strftime("%d %b") }
          end
        end
      end
    end

    columns do
      column do
        panel "Employees by Department" do
          table_for Department.all do
            column("Department") { |d| d.name }
            column("Employees")  { |d| d.employees.where(employment_status: :active).count }
            column("Manager")    { |d| d.manager&.full_name || "—" }
          end
        end
      end
    end

  end
end