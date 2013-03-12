CookBook::Application.routes.draw do

  devise_for :users, :controllers => { :omniauth_callbacks => 'users/omniauth_callbacks' }

  resources :users do
    resources :recipes do
      resources :directions
      resources :ingredients
    end
  end

  authenticated do
    root :to => 'recipes#index'
  end

  root to: 'home#index'

end
