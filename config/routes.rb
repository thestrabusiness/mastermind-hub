Rails.application.routes.draw do
  constraints Clearance::Constraints::SignedIn.new do
    root to: 'groups#index', as: :signed_in_root
  end

  constraints Clearance::Constraints::SignedOut.new do
    root to: 'sessions#new'
  end

  resource :timer

  resources :groups
  resources :group_invites do
    member do
      post 'accept'
      post 'reject'
    end
  end
  resources :users, only: :create
end
