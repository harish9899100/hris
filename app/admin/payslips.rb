ActiveAdmin.register Payslip do
  permit_params :employee_id, :month, :year, :gross, :deductions, :net

  index do
    selectable_column
    id_column
    column :employee
    column :month
    column :year
    column :gross
    column :deductions
    column :net
    column :created_at
    actions
  end

  # Filters
  filter :employee
  filter :month
  filter :year
  filter :gross
  filter :net
  filter :created_at

  form do |f|
    f.inputs do
      f.input :employee
      f.input :month
      f.input :year
      f.input :gross
      f.input :deductions
      f.input :net
    end
    f.actions
  end

  show do
    attributes_table do
      row :id
      row :employee
      row :month
      row :year
      row :gross
      row :deductions
      row :net
      row :created_at
      row :updated_at
    end
  end
end