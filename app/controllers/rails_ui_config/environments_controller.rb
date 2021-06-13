class RailsUiConfig::EnvironmentsController < ApplicationController
  before_action :set_environment

  def edit
  end

  def update
    @environment.update(environment_params)

    redirect_to edit_environment_path(@environment)
  end

  private

  def environment_params
    params.require(:environment).permit(:cache_classes, :eager_load, :log_level)
  end

  def set_environment
    @environment = RailsUiConfig::Config::Environment.find(params[:id])
  end
end
