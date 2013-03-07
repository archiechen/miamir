class DashboardController < ApplicationController
  def index
    @tasks = Task.all
  end
end
