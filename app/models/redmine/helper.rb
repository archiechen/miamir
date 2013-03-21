module Redmine::Helper
  def self.create_time_entry(time_entry,redmine_key)
    uri = URI.parse(ENV['redmine_root']+"/time_entries.json")
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Post.new(uri.request_uri)
    request.body = time_entry.to_json
    request["content-type"] = "application/json"
    request["X-Redmine-API-Key"] = redmine_key
    response = http.request(request)

    return response.body
  end

  def self.create_issue(issue,redmine_key)
    uri = URI.parse(ENV['redmine_root']+"/issues.json")
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Post.new(uri.request_uri)
    request.body = issue.to_json
    request["content-type"] = "application/json"
    request["X-Redmine-API-Key"] = redmine_key
    response = http.request(request)

    return response.body
  end

  def self.update_issue(id,issue,redmine_key)
    uri = URI.parse(ENV['redmine_root']+"/issues/"+id+".json")
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Put.new(uri.request_uri)
    request.body = issue.to_json
    request["content-type"] = "application/json"
    request["X-Redmine-API-Key"] = redmine_key
    response = http.request(request)

    return response.body
  end
end