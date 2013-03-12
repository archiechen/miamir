#encoding: utf-8
class Task < ActiveRecord::Base
  attr_accessible :partner, :owner,:estimate, :description, :status, :title

  belongs_to :owner, :class_name=>"User", :foreign_key=>"owner_id"
  belongs_to :partner, :class_name=>"User", :foreign_key=>"partner_id"

  has_many :durations

  before_save :default_values

  def default_values
    self.estimate ||= 0
    self.status ||='New'
  end

  def checkin(user)
    logger.debug user.is_idle()
    if user.is_idle()
      if self.estimate == 0
        raise ActiveResource::ResourceConflict, "Resource Conflict"
      end
      Task.transaction do
        self.durations.create!(:owner=>user)
        self.update_attributes!(:owner=>user,:status=>'Progress')
      end
    else
      raise ActiveResource::BadRequest,"Bad Request"
    end
  end

  def checkout(user,status='Ready')
    self.check_owner(user)
    Task.transaction do
      duration = self.durations.where(:owner_id=>user.id,:minutes=>nil).first
      duration.update_attributes(:minutes=>((Time.now-duration.created_at)/1.minute).ceil) if duration
      self.update_attributes(:owner=>nil,:partner=>nil,:status=>status)
    end
  end

  def done(user)
    self.checkout(user,'Done')
  end

  def cancel()
    Task.transaction do
      self.update_attributes(:status=>'New')
    end
  end

  def pair(user)
    if not user.is_owner_of(self)
      if not user.is_idle()
        raise ActiveResource::BadRequest,"Bad Request"
      end
      Task.transaction do
        duration = self.durations.where(:owner_id=>self.owner.id,:minutes=>nil).first
        duration.update_attributes(:minutes=>((Time.now-duration.created_at)/1.minute).ceil)
        self.durations.create!(:owner=>self.owner,:partner=>user)
        self.update_attributes(:partner=>user)
      end
    end
  end

  def leave(user)
    if self.partner==user
      Task.transaction do
        duration = self.durations.where(:partner_id=>user.id,:minutes=>nil).first
        duration.update_attributes(:minutes=>((Time.now-duration.created_at)/1.minute).ceil)
        self.durations.create!(:owner=>self.owner,:partner=>nil)
        self.update_attributes(:partner=>nil)
      end
    end
  end

  protected

  def check_owner(user)
    if (self.owner) and (not user.is_owner_of(self))
      raise ActiveResource::UnauthorizedAccess,"Unauthorized Access"
    end
  end

end
