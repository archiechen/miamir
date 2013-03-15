class DurationsController < ApplicationController
  # GET /tasks/1/durations
  # GET /tasks/1/durations.json
  def index
    @durations = Task.find(params[:task_id]).durations
    render json: @durations.to_json(:only => [:minutes,:created_at,:partner_id],:include=>{:owner=>{:only=>[:gravatar,:email]},:partner=>{:only=>[:gravatar,:email]}})
  end
end
