IapExampleApp::Application.routes.draw do
  root :to => "home#index"
  devise_for :users, :controllers => {:registrations => "registrations"}
  resources :users
  namespace :api do
    namespace :v1 do
      resources :purchase, controller: :iaps, only: :create
    end
  end
end
