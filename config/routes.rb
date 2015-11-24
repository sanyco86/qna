Rails.application.routes.draw do
  get 'comment/create'

  devise_for :users
  root to: 'questions#index'

  concern :votable do
    member do
      patch :upvote
      patch :downvote
      patch :unvote
    end
  end

  concern :commentable do |options|
    resources :comments, options
  end

  resources :questions, concerns: :votable do
    concerns :commentable, only: :create, defaults: {commentable: 'questions'}

    resources :answers, shallow: true, concerns: :votable do
      concerns :commentable, only: :create, defaults: {commentable: 'answers'}
      patch :make_best, on: :member
    end
  end
end