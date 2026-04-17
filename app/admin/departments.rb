ActiveAdmin.register Department do
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
      Department.unscoped.includes(:manager)   
    end

    def create
      build_resource
      resource.organization = Organization.first 

      if resource.save
        redirect_to resource_path(resource), notice: "Department created successfully"
      else
        flash[:error] = resource.errors.full_messages.join(", ")
        render :new
      end
    end
  end
end
