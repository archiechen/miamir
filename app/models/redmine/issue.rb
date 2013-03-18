#encoding: utf-8
class Redmine::Issue
  attr_accessor :project_id,:subject,:priority_id,:tracker_id

  def initialize(task)
    self.project_id  = task.team.redmine_project_id
    self.subject = task.title
    self.priority_id = 4
    self.tracker_id = 2
    
  end

  def to_json(options = {})
    { "issue"=> self}.to_json(options)
  end

end