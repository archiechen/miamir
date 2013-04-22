class Accumulation < ActiveRecord::Base
  attr_accessible :amount, :status, :team_id

  belongs_to :team
end
