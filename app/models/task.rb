#encoding: utf-8
require 'pp'
class Task < ActiveRecord::Base
  attr_accessible :partner, :owner,:estimate, :description, :status, :title

  belongs_to :owner, :class_name=>"User", :foreign_key=>"owner_id"
  belongs_to :partner, :class_name=>"User", :foreign_key=>"partner_id"

  has_many :durations

  before_save :default_values

  validate :user_own_only_one_task,:progress_must_be_estimated

  def checkin(user)
    Task.transaction do
      self.durations.create!(:owner=>user)
      self.update_attributes!(:owner=>user,:status=>'Progress')
    end
  end

  def checkout(user,status='Ready')
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

  private 
    def default_values
      self.estimate ||= 0
      self.status ||='New'
    end

    def user_own_only_one_task
      if (status=='Progress') and (!owner.idle?)
        errors[:duplicate_task]<<"user own only one task"
      end
    end

    def progress_must_be_estimated
      if (status=='Progress') and (estimate == 0)
        errors[:estimate]<<"progress must be estimated"
      end
    end

end
