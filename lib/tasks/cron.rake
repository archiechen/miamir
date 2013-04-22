namespace :cron do
  desc "daily jobs for emptying and burning."
  task :daily_job => :environment do
    Rails.logger.info "job starting ..."
    Team.burning()
    Rails.logger.info "burning ending ..."
    Team.accumulate()
    Rails.logger.info "job ending ..."
  end
end