class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :confirmed_at
  # attr_accessible :title, :body

  has_one :task,:foreign_key=>"owner_id"

  has_many :team,:foreign_key=>"owner_id"

  has_one :partnership,:class_name=>"Task",:foreign_key=>"partner_id"

  has_and_belongs_to_many :teams

  before_create :set_gravatar

  def short_name
    self.email.split("@")[0]
  end

  def idle?
    return (self.task.nil?)&&(self.partnership.nil?) 
  end

  def is_owner_of(task)
    return (task.owner != nil) && (task.owner.id==self.id)
  end

  private
    def set_gravatar
      self.gravatar = Digest::MD5.hexdigest(self.email)
    end

end
