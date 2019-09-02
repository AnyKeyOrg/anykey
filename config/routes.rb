Rails.application.routes.draw do
    
  devise_for :users,
             controllers: { invitations: "users/invitations" },
             path_names: { sign_in: "login", sign_out: "logout" }
  
  scope "(:locale)", locale: /#{I18n.available_locales.join("|")}/ do
    resources :pledges,     only: [ :index, :create, :show ], path: :pledge
    resources :affiliates,  only: [ :index ]
    resources :resources,   only: [ :index ]
    resources :stories,     only: [ :index ]
    resources :reports,     only: [ :new, :create ], path: :report

    authenticated :user do
      root to: "home#index", as: :authenticated_user_root
    end
  
    unauthenticated do
      root to: "home#index"
    end

    # get '/admin' => 'admin#index', :as => :admin
    resources :staff,      only: [ :index ]

  end
    
end
