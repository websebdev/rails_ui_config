# TODO: Should we use autoload instead of require here? Probably yes
require "rails_ui_config/version"
require "rails_ui_config/engine"
require "rails_ui_config/configurator"
# require "rails_ui_config/config/old_environment.rb"
require "rails_ui_config/config/environment.rb"
require "rails_ui_config/config/ruby_file_manager.rb"

module RailsUiConfig
end
