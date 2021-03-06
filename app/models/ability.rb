class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    can :manage, Message, author: user
    cannot :update, Message, paid?: true
    cannot :select_project, Message, paid?: true
    cannot :confirm_payment, Message, paid?: true
    can :pay, Message, author: user
    cannot :pay, Message, paid?: true
    if user.active_volunteer?
      can :take_messages, Project
      can :download_messages, Project
      can :downloaded_messages, Project
    end

    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user permission to do.
    # If you pass :manage it will apply to every action. Other common actions here are
    # :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. If you pass
    # :all it will apply to every resource. Otherwise pass a Ruby class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details: https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end
