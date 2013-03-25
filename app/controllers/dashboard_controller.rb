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

  def review
    if @current_team
      @tasks = @current_team.tasks.where(:status=>['Ready','Done'],:updated_at => (Time.now.prev_week)..(Time.now.beginning_of_week)).all
    end
  end

  def burning
    @burnings = []
    @velocity = []
    start = DateTime.now.beginning_of_day
    10.times do
      start += 1.day
      @burnings.push([(start).to_i*1000,rand(100)])
      @velocity.push([(start).to_i*1000,rand(10)])
    end

    start += 1.day
    @burnings.push([(start).to_i*1000,nil])
    @velocity.push([(start).to_i*1000,nil]) 
    start += 1.day
    @burnings.push([(start).to_i*1000,nil])
    @velocity.push([(start).to_i*1000,nil])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: [@burnings,@velocity] }
    end
  end
end
