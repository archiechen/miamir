class Ability
  include CanCan::Ability

  def initialize(user)
    if user.blank?
      # not logged in
      cannot :list, :all
    else
      # admin
      can :manage, Team, :owner_id => user.id
    end
  end
end
