Rails.application.routes.draw do
  
  scope "(:locale)", locale: /#{I18n.available_locales.join("|")}/ do
    resources :pledges, only: [:index, :create, :show], path: :pledge
    root to: 'pledges#index'
  end  
    
end
