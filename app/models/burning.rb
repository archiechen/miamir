class Burning < ActiveRecord::Base
  attr_accessible :burning, :remain, :team_id
  default_scope order('created_at')

  belongs_to :team
end
