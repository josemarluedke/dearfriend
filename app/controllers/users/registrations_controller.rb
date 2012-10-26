class Users::RegistrationsController < Devise::RegistrationsController
  def update
    if !current_user.volunteer && params[:user][:volunteer]
      flash[:alert] = "You're almost a volunteer. We just need verify your appliance."
    end
    super
  end
  def create
    if params[:user][:volunteer]
      flash[:alert] = "You're almost a volunteer. We just need verify your appliance."
    end
    super
  end
end
