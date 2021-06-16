RailsUiConfig::Engine.routes.draw do
  root "environments#index"
  resources :environments, only: [:edit, :update]
end
