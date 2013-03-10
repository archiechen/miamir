class Duration < ActiveRecord::Base
  attr_accessible :minutes, :owner, :task_id
  belongs_to :owner, :class_name=>"User", :foreign_key=>"owner_id"
end
