class DashboardController < ApplicationController

  def index
    @ready_tasks = @current_team.tasks.where(:status=>'Ready').all
    @progress_tasks = @current_team.tasks.where(:status=>'Progress').all
    @done_tasks = @current_team.tasks.where(:status=>'Done').all
  end

  def planning
    @ready_tasks = @current_team.tasks.where(:status=>'Ready').all
    @backlog_tasks = @current_team.tasks.where(:status=>'New').all
  end


end
