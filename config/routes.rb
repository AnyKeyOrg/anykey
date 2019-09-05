Rails.application.routes.draw do
    
  devise_for :users, controllers: { invitations: "users/invitations" },
             path_names:  { sign_in: "login", sign_out: "logout" }
                       
  scope "(:locale)", locale: /#{I18n.available_locales.join("|")}/ do
  
    authenticated :user do
      root to: "home#index", as: :authenticated_user_root
    end
  
    unauthenticated do
      root to: "home#index"
    end
  
    resources :pledges,                        only: [ :index, :create, :show ], path: :pledge
    resources :affiliates,                     only: [ :index ]
    resources :resources,                      only: [ :index ]
    resources :stories,                        only: [ :index ]
    resources :reports,                        only: [ :new, :create ], path: :report
                                                
    # Authenticated users only                  
    resources :staff,                          only: [ :index ]
    get  '/staff/reports'    ,                 to: 'staff#reports',            as: :staff_reports
    get  '/staff/reports/:id',                 to: 'staff#report_review',      as: :staff_report_review
    post '/staff/reports/:id/dismiss',         to: 'staff#report_dismiss',     as: :staff_report_dismiss
    post '/staff/reports/:id/undismiss',       to: 'staff#report_undismiss',   as: :staff_report_undismiss
    get  '/staff/reports/:id/new_warning',     to: 'staff#new_warning',        as: :staff_new_warning
    post '/staff/reports/:id/create_warning',  to: 'staff#create_warning',     as: :staff_create_warning
                                       
    resources :users,                          only: [ :edit, :update ]
    post '/users/:id/remove_avatar',           to: 'users#remove_avatar',      as: :remove_avatar
    
  end
    
end
