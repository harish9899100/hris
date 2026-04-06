ActiveAdmin.register AttendanceRecord do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :employee_id, :date, :check_in, :check_out, :status
  #
  # or
  #
  # permit_params do
  #   permitted = [:employee_id, :date, :check_in, :check_out, :status]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  index do
    selectable_column
    id_column
    column :employee_id
    column :date
    column :check_in
    column :check_out
    column :status
    column :created_at
    actions
  end
  filter :employee
  filter :date
  filter :check_in
  filter :check_out
  filter :status
  filter :created_at

  form do |f|
    f.inputs do
      f.input :employee
      f.input :date, as: :datepicker
      f.input :check_in, as: :datetime_picker
      f.input :check_out, as: :datetime_picker
      f.input :status, as: :select, collection: AttendanceRecord.statuses.keys
    end
    f.actions
  end

  show do
    attributes_table do
      row :id
      row :employee
      row :date
      row :check_in
      row :check_out
      row :status
      row :created_at
      row :updated_at
    end
  end


  
end
