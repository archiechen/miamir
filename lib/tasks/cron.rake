namespace :cron do
  desc "daily jobs for emptying and burning."
  task :daily_job => :environment do
    Rails.logger.info "job starting ..."
    # every day of the week at 22:00 (10pm)
    Task.emptying()
    Team.burning()
    Rails.logger.info "job ending ..."
  end
end