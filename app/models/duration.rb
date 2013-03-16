class Duration < ActiveRecord::Base
  attr_accessible :minutes,:partner,:owner, :task_id
  belongs_to :owner, :class_name=>"User", :foreign_key=>"owner_id"
  belongs_to :partner, :class_name=>"User", :foreign_key=>"partner_id"

  before_save :default_values

  private 
    def default_values
      self.minutes ||= 0
    end
end
