class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate_user!,:set_default_team

  private

    def set_default_team
      if session[:current_team].blank?
        session[:current_team] = current_user.teams.first
      end
      @current_team = session[:current_team]
    end
end
