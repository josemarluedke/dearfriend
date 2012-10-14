class MessagesController < ApplicationController
  inherit_resources
  before_filter :authenticate_user!
  load_and_authorize_resource
  respond_to :html, :json
  actions :new, :create, :update

  def new
    resource.project_id = params[:project_id]
    new!
  end

  def create
    create! do
      resource.author = current_user
      render :new and return unless resource.save
      if resource.letter_with_project?
        redirect_to confirm_payment_message_path(resource)
      else
        redirect_to select_project_message_path(resource)
      end
      return
    end
  end

  def update
    update! do
      if resource.letter_with_project?
        redirect_to confirm_payment_message_path(resource)
      else
        @projects = Project.all
        render :select_project
      end
      return
    end
  end

  # GET /messages/1/select_project
  def select_project
    @message = Message.find(params[:id])
    @projects = Project.all_can_receive_messages
  end

  # GET /messages/1/confirm_payment
  def confirm_payment
    @message = Message.find(params[:id])
    @project = @message.project
    unless @message.letter_with_project?
      flash[:alert] = "You must select a project before pay for your letter."
      redirect_to select_project_message_path(resource)
    end
  end
end
