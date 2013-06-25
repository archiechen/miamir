class DashboardController < ApplicationController
  before_filter :authenticate_user!
  skip_authorization_check

  def kanban
    if @current_team
      @backlog_tasks = @current_team.tasks.where(:status=>'New').all
      @ready_tasks = @current_team.tasks.where(:status=>'Ready').all
      @progress_tasks = @current_team.tasks.where(:status=>'Progress').all
      @done_tasks = @current_team.tasks.where(:status=>'Done').limit(20)
    end
    @task = Task.new
  end

  def review
    if @current_team
      @tasks = @current_team.tasks.where(:status=>['Ready','Done'],:updated_at => (Time.now.prev_week)..(Time.now.beginning_of_week)).all
    end
  end

  def index
    @burning = []
    @remain = []
    @ready =[]
    @progress =[]
    @done =[]
    start = DateTime.now.beginning_of_day - 14.day
    if !@current_team.nil?
      burnings = @current_team.burnings.where("created_at >= ?",start)
      accumulations = @current_team.accumulations.where("created_at >= ?",start).group_by{|d| d[:status]}
      
      @remain = burnings.map{|m|[m[:created_at].beginning_of_day.to_i*1000,m[:remain]]}
      @burning = burnings.map{|m|[m[:created_at].beginning_of_day.to_i*1000,m[:burning]]}
      @ready = accumulations["Ready"].try(:map) {|m|[m[:created_at].beginning_of_day.to_i*1000,m[:amount]]}
      @progress = accumulations["Progress"].try(:map) {|m|[m[:created_at].beginning_of_day.to_i*1000,m[:amount]]}
      @done = accumulations["Done"].try(:map) {|m|[m[:created_at].beginning_of_day.to_i*1000,m[:amount]]}
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: [@burning,@remain] }
    end
  end
end
