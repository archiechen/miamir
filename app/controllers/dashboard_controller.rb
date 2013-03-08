class DashboardController < ApplicationController
  before_filter :authenticate_user!

  def index
    @ready_tasks = Task.where(:status=>'Ready').all
    @progress_tasks = Task.where(:status=>'Progress').all
    @done_tasks = Task.where(:status=>'Done').all

    logger.debug current_user
  end

end
