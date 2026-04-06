ActiveAdmin.register Department do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :name, :description, :manager_id
  #
  # or
  #
  # permit_params do
  #   permitted = [:name, :description, :manager_id]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  permit_params :name, :description, :manager_id, :created_at

  menu priority: 3, label: "Departments"

  index do
    selectable_column
    id_column
    column :name
    column :description
    column("Manager") { |d| d.manager ? link_to(d.manager.full_name, admin_employee_path(d.manager)) : "-"}
    column("Employees") { |d| d.employees.where(employment_status: :active).count}
    column :created_at
    actions
  end

  filter :name
  filter :manager, as: :select, collection: -> { Employee.where(employment_status: :active).map { |e| [e.full_name, e.id] } }
  filter :created_at

  form do |f|
    f.inputs do
      f.input :name
      f.input :description
      f.input :manager, as: :select, collection: Employee.where(employment_status: :active).map { |e| [e.full_name, e.id] }, include_blank: "— Select Manager —"
    end
    f.actions
  end
  controller do
    def scoped_collection
      super.includes(:manager)
    end
  end
end
