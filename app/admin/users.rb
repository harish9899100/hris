ActiveAdmin.register User do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :name, :email, :employee_id #, :api_key, :employee_id, :reset_password_token, :reset_password_sent_at, :remember_created_at
  #
  # or
  #
  # permit_params do
  #   permitted = [:name, :email, :api_key, :encrypted_password, :employee_id, :reset_password_token, :reset_password_sent_at, :remember_created_at]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  #permit_params :name, :slug, :setting

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
      f.input :employee
    end
    f.actions
  end
  
end
