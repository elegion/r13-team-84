Quiz::Application.routes.draw do

  root 'home#default_locale'

  scope '/:locale', :constraints => {:locale => /(ru|en)/} do
    root :to => 'home#index', :as => :home

    resources :rooms, only: [ :show ] do
      post :join, on: :collection
    end

    resources :users, only: :show
  end

  scope :auth do
    get ':provider/callback', to: 'sessions#callback'
    get :failure, to: 'sessions#failure'
    get :signout, to: 'sessions#signout'
    post :signout, to: 'sessions#destroy'
  end

end
