Rails.application.routes.draw do
  
  resources :pledges, only: [:index, :create]
  
  root to: 'pledges#index'
  
end
