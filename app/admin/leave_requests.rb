ActiveAdmin.register LeaveRequest do
  permit_params :employee_id, :leave_type, :start_date, :end_date, :status, :approved_by_id, :reason
  index do
    selectable_column
    id_column
    column :employee
    column :leave_type
    column :start_date
    column :end_date
    column :status
    column :approved_by
    column :created_at
    actions
  end

  filter :employee
  filter :leave_type
  filter :status
  filter :start_date
  filter :end_date
  filter :approved_by
  filter :created_at

  form do |f|
    f.inputs "Leave Request Details" do
      f.input :employee, collection: Employee.all.map { |e| [e.full_name, e.id] }
      f.input :leave_type, as: :select, collection: LeaveRequest::LEAVE_TYPES
      f.input :start_date, as: :datepicker
      f.input :end_date, as: :datepicker
      f.input :status, as: :select, collection: LeaveRequest.statuses.keys
      f.input :approved_by, collection: AdminUser.all.map { |u| [u.email, u.id] }
      f.input :reason
    end
    f.actions
  end

  show do
    attributes_table do
      row :id
      row :employee
      row :leave_type
      row :start_date
      row :end_date
      row :status
      row :approved_by
      row :reason
      row :created_at
      row :updated_at
    end
  end
end
