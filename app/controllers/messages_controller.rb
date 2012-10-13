class MessagesController < ApplicationController
  inherit_resources
  respond_to :html, :json
  actions :new, :create, :update

  def new
    new!
  end

  def create
    create! do
      resource.author = current_user
      if resource.save
        redirect_to select_project_message_path(resource)
      else
        render :new
      end
      return
    end
  end

  def update
    update! do
      if resource.letter_with_project?
        redirect_to action: :confirm_payment, id: resource.id
      else
        render :select_project
      end
      return
    end
  end

  def select_project
  end

  def confirm_payment
  end
end
