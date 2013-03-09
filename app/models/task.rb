class Task < ActiveRecord::Base
  attr_accessible :owner, :description, :status, :title

  belongs_to :owner, :class_name=>"User", :foreign_key=>"owner_id"

  def checkin(user)
    if user.task
      self.errors.add(:checkin_on, "Bad Request") 
      return false
    end 
    self.update_attributes(:owner=>user,:status=>'Progress')
  end

  def checkout
    self.update_attributes(:owner=>nil,:status=>'Ready')
  end

  def done
    self.update_attributes(:owner=>nil,:status=>'Done')
  end

end
