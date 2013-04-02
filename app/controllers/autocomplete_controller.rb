class AutocompleteController < ApplicationController
  skip_authorization_check
  def users
    prefix = params[:term]
    @users = User.where("email LIKE :prefix and id not in (:members)", prefix: "#{prefix}%",members: @current_team.members.map {|m| m[:id]})

    render json: @users.map {|u| u[:email]}
  end
end
