Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  devise_for :users

  resources :dashboards, only: [:index] do
    collection { get :index }
  end

  resources :attendance_records, only: [:index] do
    collection do
      post :check_in
      post :check_out
    end
  end

  resources :leave_requests, only: [:index, :show, :new, :create] do
    member { patch :cancel }
  end

  resources :employees
  resources :departments
  resources :positions
  resources :payslips, only: [:index, :show]
  resources :profiles, only: [:show]

  get "up" => "rails/health#show", as: :rails_health_check

  authenticated :user do
    root to: "dashboards#index", as: :authenticated_root
  end
  root "homes#index"
end
