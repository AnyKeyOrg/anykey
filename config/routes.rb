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
  
    resources :pledges,        only: [ :index, :create, :show ]
    get '/pledge',             to: 'pledges#new',    as: :new_pledge
    get '/take-the-pledge',    to: 'pledges#new'
    get '/glhf',               to: 'pledges#new',    as: :glhf
    get 'referral-lookup',     to: 'pledges#referral_lookup', as: :referral_lookup
    post 'referral-send',      to: 'pledges#referral_send', as: :referral_send
    resources :affiliates,     only: [ :index, :new, :create, :edit, :update ]
    resources :resources,      only: [ :index ]
    get '/research',           to: 'resources#index',          as: :research
    get '/keystone-code',      to: 'resources#keystone_code',  as: :keystone_code    
    get '/inclusion-101',      to: 'resources#inclusion_101',  as: :inclusion_101    
    resources :stories,        only: [ :index, :new, :create, :edit, :update ]
    get '/changemakers',       to: 'stories#changemakers',     as: :changemakers
    resources :reports,        only: [ :index, :show, :new, :create ] do
      member do
        post :dismiss
        post :undismiss
      end
      resources :warnings,     only: [ :new, :create ]
      resources :revocations,  only: [ :new, :create ]
    end
    get '/report',             to: 'reports#new',        as: :short_report
    get '/verification',       to: 'verifications#new',  as: :new_verification
    resources :verifications,  only: [ :index, :show, :create ] do
      member do
        post :ignore
        post :unignore
        get  :verify_eligibility
        get  :deny_eligibility
        post :verify
        post :deny
        post :resend_cert
      end
    end

    resources :staff,          only: [ :index ]
    resources :users,          only: [ :index, :show, :edit, :update ]
    post '/users/:id/remove_avatar', to: 'users#remove_avatar', as: :remove_avatar
    
    get '/about',              to: 'about#index',        as: :about
    get '/contact',            to: 'about#contact',      as: :contact
    get '/data-policy',        to: 'about#data_policy',  as: :data_policy
    get '/logo-guide',         to: 'about#logo_guide',   as: :logo_guide
    get '/work-with-us',       to: 'about#work_with_us', as: :work_with_us
    get '/donate',             to: 'donate#index',       as: :donate
    get '/donate/success',     to: 'donate#success',     as: :donate_success

  end
  
end
