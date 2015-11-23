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

  concern :commentable do
    resources :comments, only: :create
  end

  resources :questions, concerns: [:commentable, :votable] do
    resources :answers, shallow: true, concerns: [:commentable, :votable] do
      patch :make_best, on: :member
    end
  end
end