#encoding: utf-8
class MembersController < ApplicationController
  before_filter :authenticate_user!
  authorize_resource :team
  # POST /teams/1/members
  def create
    @team = @current_team
    @member = User.where(params[:member]).first
    if @member.nil?
      render json:{:message => "user not found."},:status => :not_found
    else
      @team.members<<@member
      respond_to do |format|
        if @team.save()
          format.json { render json: @member }
        else
          format.html { redirect_to teams_path notice: 'Team was failed updated.'}
          format.json { head :no_content }
        end
      end
    end
  end

  # DELETE /teams/1/members/1
  # DELETE /teams/1/members/1.json
  def destroy
    @team = @current_team
    @team.members.delete(current_user)
    if @current_team == @team
      session[:current_team]=nil
    end

    respond_to do |format|
      format.html { redirect_to teams_url }
      format.json { head :no_content }
    end
  end
end
