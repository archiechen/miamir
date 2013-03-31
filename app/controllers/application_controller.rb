class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :set_default_team
  check_authorization :unless => :devise_controller?

  private

    def set_default_team
      if current_user and session[:current_team].blank?
        session[:current_team] = current_user.teams.first
      end
      @current_team = session[:current_team]
      puts @current_team.members
    end
end
