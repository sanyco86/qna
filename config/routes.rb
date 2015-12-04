require 'sidekiq/web'
Rails.application.routes.draw do

  mount Sidekiq::Web, at: '/statusjobs'
  use_doorkeeper
  namespace :api, defaults: {format: 'json'} do
    namespace :v1 do
      resources :profiles do
        get :me, on: :collection
      end
      resources :questions, shallow: true do
        resources :answers
      end
    end
  end

  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }
  devise_scope :user do
    post '/finish_sign_up' => 'omniauth_callbacks#finish_sign_up'
  end
  root to: 'questions#index'

  concern :votable do
    member do
      patch :upvote
      patch :downvote
      patch :unvote
    end
  end

  resources :questions, concerns: :votable do
    resources :comments, defaults: {commentable: 'questions'}

    resources :answers, shallow: true, concerns: :votable do
      resources :comments, defaults: {commentable: 'answers'}
      patch :make_best, on: :member
    end
  end
end