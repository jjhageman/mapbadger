Mapbadger::Application.routes.draw do

  devise_for :companies
  devise_scope :company do
    get "login" => "devise/sessions#new"
    delete "logout" => "devise/sessions#destroy"
    get "register" => "devise/registrations#new"
    get "verification" => "devise/confirmations#new"
  end

  #get 'signin' => 'devise/sessions#new', :as => :new_company_session
  #post 'signin' => 'devise/sessions#create', :as => :company_session
  #delete 'signout' => 'devise/sessions#destroy', :as => :destroy_company_session

  resources :representatives do
    collection do
      get 'import'
      post 'import' => 'representatives#upload'
    end
  end

  resources :opportunities do
    collection do
      get 'import'
      post 'import' => 'opportunities#upload'
    end
  end

  match 'import' => 'opportunities#import'
  match 'territory_opportunities' => 'territories#territory_opportunities'
  match 'nasdaq_companies' => 'nasdaq_companies#index'

  resources :territories
  resources :zipcodes
  resources :regions
  resources :geometries

  match '/welcome' => "territories#index", :as => :company_root
  get '/' => 'home#index', :as => :notifications
  post '/' => 'home#create', :as => :notification
  root :to => 'home#index'
end
