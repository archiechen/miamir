class Team < ActiveRecord::Base
  attr_accessible :name,:redmine_project_id
  has_many :tasks
  has_and_belongs_to_many :members,:class_name=>"User"
end
