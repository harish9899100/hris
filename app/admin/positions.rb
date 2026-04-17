ActiveAdmin.register Position do
  permit_params :title, :department_id, :employment_type, :base_salary

  menu priority: 4, label: "Positions"

  filter :title
  filter :department, as: :select,
         collection: -> { Department.all.map { |d| [d.name, d.id] } }
  filter :employment_type, as: :select,
         collection: Position.employment_types.keys.map { |t| [t.humanize, t] }
  filter :base_salary_gteq, label: "Base Salary At Least"
  filter :base_salary_lteq, label: "Base Salary At Most"

  index do
    selectable_column
    id_column
    column :title
    column :department
    column :employment_type do |p|
      status_tag p.employment_type,
        class: { full_time: "green", part_time: "orange", contract: "blue" }[p.employment_type.to_sym]
    end
    column("Base Salary") { |p| number_to_currency(p.base_salary, unit: "₹", precision: 0) }
    column("Employees")   { |p| p.employees.count }
    actions
  end

  show do
    attributes_table do
      row :title
      row :department
      row :employment_type
      row("Base Salary") { |p| number_to_currency(p.base_salary, unit: "₹", precision: 0) }
      row :created_at
    end

    panel "Employees in this Position" do
      table_for position.employees.includes(:department) do
        column("Name")       { |e| link_to e.full_name, admin_employee_path(e) }
        column("Department") { |e| e.department.name }
        column("Status")     { |e| status_tag e.employment_status }
        column("Salary")     { |e| number_to_currency(e.salary, unit: "₹", precision: 0) }
      end
    end
  end

  form do |f|
    f.inputs do
      f.input :title
      f.input :department, as: :select,
              collection: Department.all.map { |d| [d.name, d.id] }
      f.input :employment_type, as: :select,
              collection: Position.employment_types.keys.map { |t| [t.humanize, t] }
      f.input :base_salary
    end
    f.actions
  end

    controller do
    def scoped_collection
      Position.unscoped.includes(:department) 
    end

    def create
      build_resource
      resource.organization = Organization.first 

      if resource.save
        redirect_to resource_path(resource), notice: "Position created successfully"
      else
        flash[:error] = resource.errors.full_messages.join(", ")
        render :new
      end
    end
  end
end
