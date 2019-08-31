Rails.application.routes.draw do
  
  devise_for :users
  scope "(:locale)", locale: /#{I18n.available_locales.join("|")}/ do
    resources :pledges,     only: [ :index, :create, :show ], path: :pledge
    resources :affiliates,  only: [ :index ]
    resources :resources,   only: [ :index ]
    resources :stories,     only: [ :index ]
    resources :reports,     only: [ :new, :create ], path: :report

    root to: 'home#index'
  end
  
    
end
