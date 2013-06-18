class Team < ActiveRecord::Base
  attr_accessible :name, :owner
  has_many :tasks
  has_many :burnings
  has_many :accumulations

  has_and_belongs_to_many :members,:class_name=>"User"

  belongs_to :owner, :class_name=>"User", :foreign_key=>"owner_id"

  before_create :join_members

  def self.burning
    Team.all().each do |team|
      team.burnings.create(:remain => team.remain_of_today(),:burning=> team.burning_of_today())
    end
  end

  def self.accumulate
    Team.all().each do |team|
      team.accumulations.create(:status=>'Ready',:amount=>team.tasks.where(:status=>'Ready').count)
      team.accumulations.create(:status=>'Progress',:amount=>team.tasks.where(:status=>'Progress').count)
      team.accumulations.create(:status=>'Done',:amount=>team.tasks.where(:status=>'Done').count)
    end
  end

  def serializable_hash(options={})
    options = { 
      :methods => [:working_in_progress_limit,:working_in_ready_limit],
      :except =>  [:owner_id,:created_at, :updated_at]
    }.update(options)
    super(options)
  end

  def total_scale_of_backlog
    self.tasks.where(:status=>'New').sum("scale")
  end

  def remain_of_today
    remain = self.tasks.select("team_id,sum(scale) as scale").where(:status=>['Ready','Progress']).group("team_id").first
    remain.nil?? 0 : remain.scale
  end

  def burning_of_today
    burning = self.tasks.select("team_id,sum(scale) as scale").where(:status=>'Done',:updated_at => (Time.now.beginning_of_day)..(Time.now.end_of_day)).group("team_id").first
    burning.nil?? 0 : burning.scale
  end

  def working_in_progress_limit
    (self.members.count+2)
  end

  def working_in_ready_limit
    (self.members.count)
  end

  def progress_overflow?
    self.tasks.where(:status=>'Progress').count >= self.working_in_progress_limit
  end

  def ready_overflow?
    self.tasks.where(:status=>'Ready').count >= self.working_in_ready_limit
  end

  private

    def join_members
      self.members << self.owner
    end
end