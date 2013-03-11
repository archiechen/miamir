#encoding: utf-8
class Task < ActiveRecord::Base
  attr_accessible :owner,:estimate, :description, :status, :title

  belongs_to :owner, :class_name=>"User", :foreign_key=>"owner_id"
  has_many :durations

  before_save :default_values

  def default_values
    self.estimate ||= 0
  end

  def checkin(user)
    if user.task
      raise ActiveResource::BadRequest,"Bad Request"
    end
    if self.estimate == 0
      raise ActiveResource::ResourceConflict, "Resource Conflict"
    end
    Task.transaction do
      self.durations.create!(:owner=>user)
      self.update_attributes!(:owner=>user,:status=>'Progress')
    end
  end

  def checkout(user)
    self.check_owner(user)
    Task.transaction do
      duration = self.durations.where(:owner_id=>user.id,:minutes=>nil).first
      duration.update_attributes(:minutes=>((Time.now-duration.created_at)/1.minute).ceil) if duration
      self.update_attributes(:owner=>nil,:status=>'Ready')
    end
  end

  def done(user)
    self.check_owner(user)
    Task.transaction do
      duration = self.durations.where(:owner_id=>user.id,:minutes=>nil).first
      duration.update_attributes(:minutes=>((Time.now-duration.created_at)/1.minute).ceil)
      self.update_attributes(:owner=>nil,:status=>'Done')
    end
  end

  protected

  def check_owner(user)
    
    if self.owner and self.owner.id!=user.id
      raise ActiveResource::UnauthorizedAccess,"Unauthorized Access"
    end
  end

end
