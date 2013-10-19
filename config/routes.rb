Quiz::Application.routes.draw do

  root to: 'home#home'

  scope :auth do
    get ':provider/callback', to: 'sessions#callback'
    get :failure, to: 'sessions#failure'
    get :signout, to: 'sessions#signout'
    post :signout, to: 'sessions#destroy'
  end
end
