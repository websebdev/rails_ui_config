class RailsUiConfig::ArticlesController < ApplicationController
  def index
  end

  def create
    puts "GGGG"
    RailsUiConfig::Configurator.new.testa
  end
end
