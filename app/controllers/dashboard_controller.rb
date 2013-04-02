class DashboardController < ApplicationController
  before_filter :authenticate_user!
  skip_authorization_check
  
  def kanban
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

  def review
    if @current_team
      @tasks = @current_team.tasks.where(:status=>['Ready','Done'],:updated_at => (Time.now.prev_week)..(Time.now.beginning_of_week)).all
    end
  end

  def index
    @burning = []
    @remain = []
    start = DateTime.now.beginning_of_day - 7.day
    burnings = @current_team.burnings.where("created_at >= ?",start)
    10.times do
      burning = burnings.find{ |x| x.created_at.beginning_of_day == start}
      if !burning.nil?
        @remain.push([burning.created_at.beginning_of_day.to_i*1000,burning.remain])
        @burning.push([burning.created_at.beginning_of_day.to_i*1000,burning.burning])
      else
        @remain.push([(start).to_i*1000,nil])
        @burning.push([(start).to_i*1000,nil])
      end
      start += 1.day
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: [@burning,@remain] }
    end
  end
end
