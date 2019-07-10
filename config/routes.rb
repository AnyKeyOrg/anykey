Rails.application.routes.draw do
  
  resources :pledges, only: [:index, :create], path: :pledge
  
  root to: 'pledges#index'
  
end
