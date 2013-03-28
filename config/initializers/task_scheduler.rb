require 'rubygems'
require 'rufus/scheduler'  
scheduler = Rufus::Scheduler.start_new
scheduler.cron '25 15 * * 1-5 Asia/Shanghai' do
  Rails.logger.info "job starting ..."
  # every day of the week at 22:00 (10pm)
  Task.emptying()
  Team.burning()
  Rails.logger.info "job ending ..."
end