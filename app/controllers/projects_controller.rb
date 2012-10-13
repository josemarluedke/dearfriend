class ProjectsController < ApplicationController
  inherit_resources
  actions :show
  respond_to :html, :json

  # POST /projects/1/download_messages
  def download_messages
    @project = Project.find(params[:id])
    messages_file = @project.give_messages_to_volunteer(current_user,
                                                        params[:messages_quantity])
  rescue InsufficientMessagesToBeSent => e
    flash[:alert] = "There is just #{@project.total_messages_to_be_downloaded} messages to be downloaded."
    render :show
  else
    send_data messages_file, filename: "messages_#{DateTime.current}.txt"
  end
end
