Rails.application.routes.draw do
  root "lego_sets#index"

  resources :lego_sets, only: [:index, :show, :create, :destroy] do
    member do
      post :toggle_part
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
