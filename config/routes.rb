Mapbadger::Application.routes.draw do

  devise_for :companies, :controllers => { :omniauth_callbacks => "companies/omniauth_callbacks" }
  devise_scope :company do
    get "login" => "devise/sessions#new"
    get '/' => 'devise/sessions#new'
    delete "logout" => "devise/sessions#destroy"
    get "register" => "devise/registrations#new"
    get "verification" => "devise/confirmations#new"
    get "forgot_password" => "devise/passwords#new"
    get "resend" => "devise/confirmations#new"
  end

  namespace :admin do
    get 'opportunities/import'
    post 'opportunities/import' => 'opportunities#upload'
    #post 'opportunities/notify_company' => 'opportunities#notify_company'
    resources :companies do
      resources :opportunities do
        post 'notify_company', :on => :collection
      end
    end
  end

  resources :representatives do
    collection do
      get 'upload' => 'representatives#import'
      post 'upload'
      delete 'destroy_multiple'
    end
  end

  resources :opportunities do
    collection do
      get 'upload' => 'opportunities#import'
      post 'import' => 'opportunities#upload'
      get 'advanced' => 'opportunities#advanced_import'
      post 'advanced' => 'opportunities#advanced_upload'
      delete 'destroy_multiple'
    end
  end

  match 'import' => 'opportunities#import'
  match 'territory_opportunities' => 'territories#territory_opportunities'
  match 'nasdaq_companies' => 'nasdaq_companies#index'
  post 'contact' => 'contact#create'

  resources :territories
  resources :zipcodes
  resources :regions
  resources :geometries
  resources :csvs

  match '/welcome' => "territories#index", :as => :company_root
  root :to => 'devise/sessions#new'
end
