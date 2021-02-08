# frozen_string_literal: true

Rails.application.routes.draw do
  default_url_options host: ENV.fetch('host'), protocol: ENV.fetch('protocol')

  get '/auth/:provider/callback' => 'sessions#create'
  get 'signin', to: redirect('/auth/google_oauth2'), as: 'signin'
  get '/signout' => 'sessions#destroy', :as => :signout
  get '/auth/failure' => 'sessions#failure'

  root to: 'posts#index'

  resource :profile, controller: 'developers', only: %i[update edit]
  resources :developers, path: '/authors', only: 'show'

  resources :posts, except: :destroy, param: :titled_slug
  resources :statistics, only: :index

  get '/posts_drafts', to: 'posts#drafts', as: :drafts

  resources :channels, path: '/', only: :show
  post '/post_preview', to: 'posts#preview'

  get '/posts/:titled_slug.md', to: 'posts#show', as: 'post_text'

  post '/posts/:slug/like', to: 'posts#like'
  post '/posts/:slug/unlike', to: 'posts#unlike'
end
