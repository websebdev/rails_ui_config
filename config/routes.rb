RailsUiConfig::Engine.routes.draw do
  resources :environments, only: [:edit, :update]
end
