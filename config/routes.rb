Rails.application.routes.draw do
  constraints Clearance::Constraints::SignedIn.new do
    root to: 'groups#index', as: :signed_in_root
  end

  constraints Clearance::Constraints::SignedOut.new do
    root to: 'sessions#new'
  end

  resources :calls, only: [:show, :edit, :update] do
    resources :commitments, except: :destroy do
      resource :confirmation, only: :update, controller: :commitment_confirmations
    end
    resource :note, only: :create
    resource :timer, only: :create
  end

  resources :groups do
    resources :memberships, only: :destroy
  end

  resources :group_invites do
    member do
      post 'accept'
      post 'reject'
    end
  end
  resources :users, only: :create
end
