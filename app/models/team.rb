class Team < ActiveRecord::Base
  attr_accessible :name,:redmine_project_id
  has_many :tasks
  has_and_belongs_to_many :members,:class_name=>"User"

  has_many :burnings

  def self.burning
    Team.all().each do |team|
      team.burnings.create(:remain => team.remain_of_today(),:burning=> team.burning_of_today())
    end
  end

  def remain_of_today
    remain = self.tasks.select("team_id,sum(scale) as scale").where(:status=>['Ready','Progress']).group("team_id").first
    remain.nil?? 0 : remain.scale
  end

  def burning_of_today
    burning = self.tasks.select("team_id,sum(scale) as scale").where(:status=>'Done',:updated_at => (Time.now.beginning_of_day)..(Time.now.end_of_day)).group("team_id").first
    burning.nil?? 0 : burning.scale
  end
end
