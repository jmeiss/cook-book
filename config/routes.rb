CookBook::Application.routes.draw do

  resources :directions

  resources :ingredients

  resources :recipes

  devise_for :users, :controllers => { :omniauth_callbacks => 'users/omniauth_callbacks' }

  root to: 'home#index'

end
