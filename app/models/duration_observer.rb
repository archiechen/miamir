class DurationObserver < ActiveRecord::Observer
  observe :duration

  def before_update(duration)
    time_entry = Redmine::TimeEntry.new(duration)
    if time_entry.hours>0 and !User.current.redmine_key.nil?
      uri = URI.parse(ENV['redmine_root']+"/time_entries.json")
      http = Net::HTTP.new(uri.host, uri.port)
      request = Net::HTTP::Post.new(uri.request_uri)
      request.body = time_entry.to_json
      request["content-type"] = "application/json"
      request["X-Redmine-API-Key"] = User.current.redmine_key
      response = http.request(request)

      duration.logger.info(JSON.parse(response.body))
    end
  end
  
end
