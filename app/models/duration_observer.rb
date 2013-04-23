class DurationObserver < ActiveRecord::Observer
  observe :duration

  def before_update(duration)
    time_entry = Redmine::TimeEntry.new(duration)
    if time_entry.hours>0 and !duration.owner.redmine_key.nil?
      response_body = Redmine::Helper.create_time_entry(time_entry,duration.owner.redmine_key)
      begin
        Rails.logger.info(JSON.parse(response_body))

        if !duration.partner.nil? and !duration.partner.redmine_key.nil?
          response_body = Redmine::Helper.create_time_entry(time_entry,duration.partner.redmine_key)
          Rails.logger.info(JSON.parse(response_body))
        end
      rescue => e
        Rails.logger.warn(e.class)
        Rails.logger.warn(response_body)
      end
    end
  end
  
end
