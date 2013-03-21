#encoding: utf-8
class Redmine::IssueUpdated
  attr_accessor :status_id,:estimated_hours,:done_ratio,:subject,:priority_id,:description,:assigned_to_id

  def initialize(task)
    self.estimated_hours = task.estimate
    self.subject = task.title
    self.priority_id = ENV['redmine_priority_start'].to_i+(task.priority/20.0).ceil
    self.description = task.description
    self.done_ratio = 0
    if task.status == "Progress"
      self.status_id = 2
    elsif task.status == "Done"
      self.status_id = 3
      self.done_ratio = 100
    elsif task.status == "Archived"
      self.status_id = 5
    else
      self.status_id = 1
    end
    self.assigned_to_id=task.redmine_assigned_to_id
  end

  def to_json(options = {})
    { "issue"=> self}.to_json(options)
  end

end