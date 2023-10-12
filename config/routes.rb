Rails.application.routes.draw do
  devise_for :users, path: 'auth',
                     path_names: { sign_in: 'login', sign_out: 'logout', password: 'secret',
                                   confirmation: 'verification', unlock: 'unblock', registration: 'register',
                                   sign_up: 'cmon_let_me_in' }

  devise_scope :user do
    get '/users/sign_out', to: 'devise/sessions#destroy'
    root to: 'devise/sessions#new'
  end
  resources :users, only: %i[index show] do
    resources :posts, only: %i[index show new create destroy] do
      resources :comments, only: %i[new create destroy]
      resources :likes, only: %i[new create]
    end
  end

  namespace :api do
    # do not generate a url/path for the resource with --> %i[none]
    resources :users, only: %i[none] do
      # index - to list all posts for a user
      resources :posts, only: %i[index]
    end

    # do not generate a url/path for the resource with --> %i[none]
    resources :posts, only: %i[none] do
      # index - to list all comments for a post
      # new/create - to be able to create new comments
      resources :comments, only: %i[index new create]
    end
  end
end
