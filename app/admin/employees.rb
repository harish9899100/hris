ActiveAdmin.register Employee do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :first_name, :last_name, :email, :employee_id, :department_id, :position_id, :manager_id, :date_of_joining, :employment_status, :salary, :phone, :status
  #
  # or
  #
  # permit_params do
  #   permitted = [:first_name, :last_name, :email, :employee_id, :department_id, :position_id, :manager_id, :date_of_joining, :employment_status, :salary, :phone, :status]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  index do
    selectable_column
    id_column
    column :employee_id
    column :first_name
    column :last_name
    column :email
    column :department
    column :position
    column :manager
    column :date_of_joining
    column :employment_status
    column :salary
    column :phone
    #column :status
    column :created_at
    actions
  end

  filter :employee_id
  filter :first_name
  filter :last_name
  filter :email
  filter :department
  filter :position
  filter :manager
  filter :date_of_joining
  filter :employment_status
  filter :salary
  #filter :status
  filter :created_at

  form do |f|
    f.inputs "Employee Details" do
      f.input :employee_id
      f.input :first_name
      f.input :last_name
      f.input :email
      f.input :department
      f.input :position
      f.input :manager, collection: Employee.all.map { |e| [e.full_name, e.id] }
      f.input :date_of_joining, as: :datepicker
      f.input :employment_status, as: :select, collection: Employee.employment_statuses.keys
      f.input :salary
      f.input :phone
      #f.input :status, as: :select, collection: Employee.statuses.keys
    end
    f.actions
  end

  show do
    attributes_table do
      row :id
      row :employee_id
      row :first_name
      row :last_name
      row :email
      row :department
      row :position
      row :manager
      row :date_of_joining
      row :employment_status
      row :salary
      row :phone
      #row :status
      row :created_at
      row :updated_at
    end
  end
end