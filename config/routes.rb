Rails.application.routes.draw do

  get 'sessions/login'
  get 'sessions/logout'

  post 'sessions' => 'sessions#create'

  resources :posts do
    resources :comments
  end

  resources :posts do
    member do
      put "vote", to: "posts#vote"
    end
  end

  resources :favorite_posts, only: [:create, :destroy, :index]

  get 'registration' => 'users#new', as: 'registration'
  post 'users' => 'users#create'
  # You can have the root of your site routed with "root"
  root 'posts#index'

end
