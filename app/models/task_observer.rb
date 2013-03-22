class TaskObserver < ActiveRecord::Observer
  observe :task

  def before_create(task)
    if !User.current.redmine_key.nil?
      response_body = Redmine::Helper.create_issue(Redmine::Issue.new(task),User.current.redmine_key)
      issue = JSON.parse(response_body)
      task.logger.info(issue)
      task.redmine_issue_id = issue["issue"]["id"]
    else
      User.current.logger.warn("#{User.current.email} dosen't set redmine key!")
    end
  end

  def before_update(task)
    owner = User.current.nil?? task.owner : User.current
    if !owner.redmine_key.nil?
      if task.status_changed?
        response_body = Redmine::Helper.update_issue(task.redmine_issue_id.to_s,Redmine::IssueUpdated.new(task), owner.redmine_key)
        task.logger.info(response_body)
      end
    else
      User.current.logger.warn("#{User.current.email} dosen't set redmine key!")
    end
  end

  def before_destroy(task)
    if !task.redmine_issue_id.nil? and !User.current.redmine_key.nil?
      uri = URI.parse(ENV['redmine_root']+"/issues/"+task.redmine_issue_id.to_s+".json")
      http = Net::HTTP.new(uri.host, uri.port)
      request = Net::HTTP::Delete.new(uri.request_uri)
      request["content-type"] = "application/json"
      request["X-Redmine-API-Key"] = User.current.redmine_key
      response = http.request(request)
      task.logger.info(response.code)
    end
  end
end
