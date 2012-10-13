class MessagesController < ApplicationController
  inherit_resources
  load_and_authorize_resource
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
        redirect_to confirm_payment_message_path(resource)
      else
        render :select_project
      end
      return
    end
  end

  # GET /messages/1/select_project
  def select_project
    @message = Message.find(params[:id])
    @projects = Project.all
  end

  # GET /messages/1/confirm_payment
  def confirm_payment
    @message = Message.find(params[:id])
    unless @message.letter_with_project?
      flash[:alert] = "You must select a project before pay for your letter."
      redirect_to select_project_message_path(resource)
    end
  end

  # POST /messages/1/pay
  def pay
  end
end
