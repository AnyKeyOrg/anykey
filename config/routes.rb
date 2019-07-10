Rails.application.routes.draw do
  
  resources :pledges, only: [:index, :create, :show], path: :pledge
  
  root to: 'pledges#index'
  
end
