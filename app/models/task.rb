#encoding: utf-8
class Task < ActiveRecord::Base
  attr_accessible :owner, :description, :status, :title

  belongs_to :owner, :class_name=>"User", :foreign_key=>"owner_id"

  def checkin(user)
    if user.task
      return false
    end 
    self.update_attributes(:owner=>user,:status=>'Progress')
  end

  def checkout(user)
    self.not_owner(user)? false : self.update_attributes(:owner=>nil,:status=>'Ready')
  end

  def done(user)
    self.not_owner(user)? false : self.update_attributes(:owner=>nil,:status=>'Done')
  end

  protected 
    def not_owner(user)
      return self.owner.id!=user.id
    end

end
