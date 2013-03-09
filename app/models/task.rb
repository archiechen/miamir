#encoding: utf-8
class Task < ActiveRecord::Base
  attr_accessible :owner,:estimate, :description, :status, :title

  belongs_to :owner, :class_name=>"User", :foreign_key=>"owner_id"

  def checkin(user)
    if user.task
      raise ActiveResource::BadRequest,"Bad Request"
    end
    self.update_attributes(:owner=>user,:status=>'Progress')
  end

  def checkout(user)
    self.check_owner(user)
    self.update_attributes(:owner=>nil,:status=>'Ready')
  end

  def done(user)
    self.check_owner(user)
    self.update_attributes(:owner=>nil,:status=>'Done')
  end

  protected

  def check_owner(user)
    if self.owner.id!=user.id
      raise ActiveResource::UnauthorizedAccess,"Unauthorized Access"
    end
  end

end
