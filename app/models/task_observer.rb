class TaskObserver < ActiveRecord::Observer
  observe :task

  def before_create(task)
    puts Redmine::Issue.new(task).to_json

    uri = URI.parse("http://192.168.6.180/redmine/issues.json?key=0a82cf345f080da882b00b3b7283ba5ffe6cbc0f")
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Post.new(uri.request_uri)
    request.body = Redmine::Issue.new(task).to_json

    request["content-type"] = "application/json"
    response = http.request(request)
    issue = JSON.parse(response.body)
    
    task.redmine_issue_id = issue["issue"]["id"]
  end

  def before_destroy(task)
    puts Redmine::Issue.new(task).to_json

    uri = URI.parse("http://192.168.6.180/redmine/issues/"+task.redmine_issue_id.to_s+".json?key=0a82cf345f080da882b00b3b7283ba5ffe6cbc0f")
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Delete.new(uri.request_uri)
    request["content-type"] = "application/json"
    response = http.request(request)
    puts response.body
  end
end
