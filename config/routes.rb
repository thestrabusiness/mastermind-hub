Rails.application.routes.draw do
  constraints Clearance::Constraints::SignedIn.new do
    root to: 'groups#index', as: :signed_in_root
  end

  constraints Clearance::Constraints::SignedOut.new do
    root to: 'sessions#new'
  end

  resources :calls, only: :show do
    resource :note, only: :create
    resources :commitments, only: :create
  end

  resources :groups do
    resource :timer, only: [:show, :create]
  end

  resources :group_invites do
    member do
      post 'accept'
      post 'reject'
    end
  end
  resources :users, only: :create
end
