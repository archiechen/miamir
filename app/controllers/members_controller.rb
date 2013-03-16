class MembersController < ApplicationController
  before_filter :authenticate_user!
  # POST /teams/1/members
  def create
    @team = Team.find(params[:team_id])
    @team.members<<current_user
    respond_to do |format|
      if @team.save()
        format.html { redirect_to teams_path, notice: 'Team was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { redirect_to teams_path notice: 'Team was failed updated.'}
        format.json { head :no_content }
      end
    end
  end

  # DELETE /teams/1/members/1
  # DELETE /teams/1/members/1.json
  def destroy
    @team = Team.find(params[:team_id])
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
