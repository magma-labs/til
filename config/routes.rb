# frozen_string_literal: true

Rails.application.routes.draw do
  default_url_options host: ENV.fetch('host'), protocol: ENV.fetch('protocol')

  unless Rails.env.production?
    namespace 'ui' do
      get '/', action: 'index'
      %w[author_index drafts home post_edit post_show statistics tag_index].each do |action|
        get action, action: action
      end
    end
  end

  get '/auth/google_oauth2/callback' => 'sessions#create'
  get '/login' => 'sessions#new', :as => :login
  get '/logout' => 'sessions#destroy', :as => :logout

  resource :session, only: %i[create destroy]

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
