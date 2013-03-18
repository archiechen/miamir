#encoding: utf-8
class Redmine::TimeEntry
  attr_accessor :issue_id,:hours,:activity_id

  def initialize(duration)
    self.issue_id  = duration.task.redmine_issue_id
    self.hours = (duration.task.redmine_issue_id.nil?)? 0 : (duration.minutes/60.0).ceil
    self.activity_id = 9
    
  end

  def to_json(options = {})
    { "time_entry"=> self}.to_json(options)
  end

end