require 'rubygems'
require 'rufus/scheduler'  
scheduler = Rufus::Scheduler.start_new
scheduler.cron '10 23 * * *' do
  # every day of the week at 22:00 (10pm)
  Task.emptying()
  Team.burning()
end