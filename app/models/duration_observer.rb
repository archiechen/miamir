class DurationObserver < ActiveRecord::Observer
  observe :duration

  def before_update(duration)
    puts Redmine::TimeEntry.new(duration).to_json
    if duration.minutes>0
      uri = URI.parse("http://192.168.6.180/redmine/time_entries.json?key=0a82cf345f080da882b00b3b7283ba5ffe6cbc0f")
      http = Net::HTTP.new(uri.host, uri.port)
      request = Net::HTTP::Post.new(uri.request_uri)
      request.body = Redmine::TimeEntry.new(duration).to_json
      request["content-type"] = "application/json"
      response = http.request(request)
      #time_entry = JSON.parse(response.body)
        
      puts response.body
    end
  end
  
end
