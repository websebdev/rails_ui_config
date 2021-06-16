class RailsUiConfig::EnvironmentsController < RailsUiConfig::ApplicationController
  before_action :set_environment, only: [:edit, :update]

  def index
    @environments = RailsUiConfig::Config::Environment.all
  end

  def edit
  end

  def update
    @environment.update(environment_params[:fields])

    redirect_to edit_environment_path(@environment)
  end

  private

  def environment_params
    params.require(:environment).permit(fields: RailsUiConfig::Config::Environment::Field::OPTIONS.keys)
  end

  def set_environment
    @environment = RailsUiConfig::Config::Environment.find(params[:id])
  end
end
