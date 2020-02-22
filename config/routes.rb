Rails.application.routes.draw do
  constraints Clearance::Constraints::SignedIn.new do
    root to: 'timers#show', as: :signed_in_root
  end

  constraints Clearance::Constraints::SignedOut.new do
    root to: 'sessions#new'
  end

  resource :timer
  resources :users, only: :create
end
