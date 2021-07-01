Rails.application.routes.draw do
  root "rails_ui_config/environments#index"
  mount RailsUiConfig::Engine => "/rails_ui_config"
end
