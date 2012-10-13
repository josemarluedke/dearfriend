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
    render :show
  end
end
