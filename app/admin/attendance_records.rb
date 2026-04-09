ActiveAdmin.register AttendanceRecord do
  permit_params :employee_id, :date, :check_in, :check_out, :status

  menu priority: 5, label: "Attendance"

  scope :all, default: true
  scope("Present Today")    { |q| q.where(date: Date.current, status: :present) }
  scope("Absent Today")     { |q| q.where(date: Date.current, status: :absent) }
  scope("Incomplete Today") { |q| q.where(date: Date.current, status: :incomplete) }
  scope("On Leave")         { |q| q.where(status: :on_leave) }

  filter :employee, as: :select, collection: -> { Employee.all.map { |e| [e.full_name, e.id] } }
  filter :date
  filter :status, as: :select, collection: -> { AttendanceRecord.statuses.keys.map { |s| [s.humanize, s] } }
  filter :created_at

  index do
    selectable_column
    id_column

    column :date

    column :employee do |attendance|
      attendance.employee&.full_name || attendance.employee_id
    end

    column("Department") do |attendance|
      attendance.employee&.department&.name || "—"
    end

    column :status do |attendance|
      status_tag attendance.status
    end

    column("Check In") do |attendance|
      attendance.check_in&.strftime("%H:%M") || "—"
    end

    column("Check Out") do |attendance|
      attendance.check_out&.strftime("%H:%M") || "—"
    end

    column("Hours") do |attendance|
      attendance.hours_worked || "—"
    end

    column :created_at
    actions
  end

  csv do
    column :date
    column("Employee")   { |a| a.employee&.full_name }
    column("Department") { |a| a.employee&.department&.name }
    column :status
    column("Check In")   { |a| a.check_in&.strftime("%H:%M") }
    column("Check Out")  { |a| a.check_out&.strftime("%H:%M") }
    column("Hours")      { |a| a.hours_worked }
  end

  batch_action :mark_absent, confirm: "Mark selected as absent?" do |ids|
    AttendanceRecord.where(id: ids).update_all(status: AttendanceRecord.statuses[:absent])
    redirect_to collection_path, notice: "Marked as absent."
  end

  show do
    attributes_table do
      row :id
      row :date

      row :employee do |attendance|
        attendance.employee&.full_name || attendance.employee_id
      end

      row("Department") do |attendance|
        attendance.employee&.department&.name || "—"
      end

      row :status do |attendance|
        status_tag attendance.status
      end

      row("Check In") do |attendance|
        attendance.check_in&.strftime("%I:%M %p") || "Not recorded"
      end

      row("Check Out") do |attendance|
        attendance.check_out&.strftime("%I:%M %p") || "Not recorded"
      end

      row("Hours Worked") do |attendance|
        attendance.hours_worked ? "#{attendance.hours_worked} hrs" : "—"
      end

      row :created_at
      row :updated_at
    end
  end

  form do |f|
    f.inputs "Attendance Details" do
      f.input :employee, as: :select, collection: Employee.all.map { |e| [e.full_name, e.id] }
      f.input :date, as: :datepicker
      f.input :check_in, as: :datetime_picker, label: "Check In Time"
      f.input :check_out, as: :datetime_picker, label: "Check Out Time"

      f.input :status, as: :select, collection: AttendanceRecord.statuses.keys.map { |s| [s.humanize, s] }
    end
    f.actions
  end

  collection_action :monthly_report, method: :get do
    @month = params[:month].present? ? Date.parse(params[:month]) : Date.current.beginning_of_month
    @employees = Employee.includes(:department)
    @records = AttendanceRecord.where(
      date: @month.beginning_of_month..@month.end_of_month
    ).group_by(&:employee_id)
  end

  action_item :monthly_report, only: :index do
    link_to "Monthly Report", monthly_report_admin_attendance_records_path
  end

  controller do
    def scoped_collection
      super.includes(employee: :department)
    end
  end
end