class Task < ActiveRecord::Base
  attr_accessible :description, :title, :created_at, :updated_at
end
