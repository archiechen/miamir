#encoding: utf-8
class Redmine::Issue
  attr_accessor :project_id,:subject,:priority_id,:tracker_id,:description

  def initialize(task)
    self.project_id  = task.team.redmine_project_id
    self.subject = task.title
    self.priority_id = ENV['redmine_priority_start'].to_i+task.priority/20
    self.tracker_id = 2
    self.description = task.description
    
  end

  def to_json(options = {})
    { "issue"=> self}.to_json(options)
  end

end