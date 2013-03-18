class TaskObserver < ActiveRecord::Observer
  observe :task

  def before_create(task)
    if !User.current.redmine_key.nil?
      puts Redmine::Issue.new(task).to_json
      uri = URI.parse("http://192.168.6.180/redmine/issues.json")
      http = Net::HTTP.new(uri.host, uri.port)
      request = Net::HTTP::Post.new(uri.request_uri)
      request.body = Redmine::Issue.new(task).to_json

      request["content-type"] = "application/json"
      request["X-Redmine-API-Key"] = User.current.redmine_key
      response = http.request(request)

      issue = JSON.parse(response.body)
      task.logger.info(issue)
      task.redmine_issue_id = issue["issue"]["id"]
    else
      User.current.logger.warn("#{User.current.email} dosen't set redmine key!")
    end

  end

  def before_destroy(task)
    if !task.redmine_issue_id.nil? and !User.current.redmine_key.nil?
      uri = URI.parse("http://192.168.6.180/redmine/issues/"+task.redmine_issue_id.to_s+".json")
      http = Net::HTTP.new(uri.host, uri.port)
      request = Net::HTTP::Delete.new(uri.request_uri)
      request["content-type"] = "application/json"
      request["X-Redmine-API-Key"] = User.current.redmine_key
      response = http.request(request)
      task.logger.info(response.code)
    end
  end
end
