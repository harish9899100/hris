ActiveAdmin.register User do

  permit_params :name, :email, :employee_id, :password, :password_confirmation #, :api_key, :employee_id, :reset_password_token, :reset_password_sent_at, :remember_created_at

  index do
    selectable_column
    id_column
    column :name
    column :email
    column :employee
    column :created_at
    actions
  end

  filter :name
  filter :email
  filter :employee
  filter :created_at

  form do |f|
    f.inputs do
      f.input :name
      f.input :email
      f.input :password
      f.input :password_confirmation
      f.input :employee
    end
    f.actions
  end
  
end
