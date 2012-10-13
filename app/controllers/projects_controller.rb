class ProjectsController < ApplicationController
  inherit_resources
  actions :show
  respond_to :html, :json

  # POST /projects/1/download_messages
  def download_messages
    @project = Project.find(params[:id])
    @project.give_messages_to_volunteer(current_user,
                                        params[:messages_quantity])
    flash[:notice] = "Download started!"
  rescue InsufficientMessagesToBeSent => e
    flash[:alert] = "There is just #{@project.total_messages_to_be_downloaded} messages to be downloaded."
  ensure
    render :show
  end
end
