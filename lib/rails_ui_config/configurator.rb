require 'rails/generators'

class RailsUiConfig::Configurator < Thor::Group
  include Thor::Actions
  include Rails::Generators::Actions

  def testa
    insert_into_file "config/environment.rb", "TESTINGGG", :after => "Rails.application.initialize!\n"
  end
end
