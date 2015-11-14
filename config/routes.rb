Rails.application.routes.draw do
  devise_for :users
  root to: 'questions#index'

  resources :questions do
    resources :answers do
      member { patch :make_best }
    end
  end
end
