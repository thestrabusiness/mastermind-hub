# frozen_string_literal: true

Rails.application.routes.draw do
  constraints Clearance::Constraints::SignedIn.new do
    root to: "groups#index", as: :signed_in_root
  end

  constraints Clearance::Constraints::SignedOut.new do
    root to: "sessions#new"
  end

  resources :calls, only: [:show, :edit, :update] do
    resources :commitments, except: :destroy do
      resource :confirmation, only: :update, controller: :commitment_confirmations
    end
    resource :note, only: :create
    resource :timer, only: :create
  end

  resources :groups do
    scope module: :groups do
      resources :group_invites, only: [:index, :create, :destroy]
    end

    resources :memberships, only: :destroy
    resources :calls, only: [:new, :create]
  end

  resources :group_invites, only: :index do
    member do
      post "accept"
      post "reject"
    end
  end

  resource :user, only: [:edit, :update, :show]
  resources :users, only: [:create]
end
