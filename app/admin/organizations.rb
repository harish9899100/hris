ActiveAdmin.register Organization do
  permit_params :name, :slug, :settings
  index do
    selectable_column
    id_column
    column :name
    column :created_at
    actions
  end

  filter :name
  filter :created_at

  form do |f|
    f.inputs do
      f.input :name
      f.input :slug
      f.input :settings
      f.input :password_confirmation
    end
    f.actions
  end
  
end
