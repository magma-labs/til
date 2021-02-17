# frozen_string_literal: true

Rails.application.routes.draw do

  get '/auth/:provider/callback' => 'sessions#create'
  delete '/signout' => 'sessions#destroy', :as => :signout
  get '/auth/failure' => 'sessions#failure'

  root to: 'posts#index'

  resources :clicks, only: :create
  resource :profile, controller: 'developers', only: %i[update edit]
  resources :developers, path: '/author/', only: 'show', param: :username

  resources :posts, except: :destroy, param: :titled_slug
  resources :statistics, only: :index

  get '/posts_drafts', to: 'posts#drafts', as: :drafts

  resources :channels, path: '/', only: :show
  post '/post_preview', to: 'posts#preview'

  get '/posts/:titled_slug.md', to: 'posts#show', as: 'post_text'

  post '/posts/:slug/like', to: 'posts#like'
  post '/posts/:slug/unlike', to: 'posts#unlike'
end
