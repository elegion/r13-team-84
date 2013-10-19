Quiz::Application.routes.draw do

  root 'home#index'

  resources :rooms, only: [ :show ] do
    post :join, on: :collection
  end

  scope :auth do
    get ':provider/callback', to: 'sessions#callback'
    get :failure, to: 'sessions#failure'
    get :signout, to: 'sessions#signout'
    post :signout, to: 'sessions#destroy'
  end

end
