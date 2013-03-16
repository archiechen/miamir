class DashboardController < ApplicationController
  before_filter :authenticate_user!
  
  def index
    if @current_team
      @ready_tasks = @current_team.tasks.where(:status=>'Ready').all
      @progress_tasks = @current_team.tasks.where(:status=>'Progress').all
      @done_tasks = @current_team.tasks.where(:status=>'Done').all
    end
  end

  def planning
    if @current_team
      @ready_tasks = @current_team.tasks.where(:status=>'Ready').all
      @backlog_tasks = @current_team.tasks.where(:status=>'New').all
    end
  end


end
