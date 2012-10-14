class ProjectsController < ApplicationController
  inherit_resources
  actions :show
  respond_to :html, :json

  # POST /projects/1/take_messages
  def take_messages
    @project = Project.find(params[:id])
    messages_file = @project.give_messages_to_volunteer(current_user,
                                                        params[:messages_quantity])
  rescue InsufficientMessagesToBeSent => e
    flash[:alert] = "There is just #{@project.total_messages_to_be_downloaded} messages to be downloaded."
    render :show
  else
    send_data messages_file, filename: "messages_#{DateTime.current}.txt"
  end

  # GET /projects/downloaded_messages
  def downloaded_messages
    @message_downloads = []
    current_user.messages_as_volunteer.group_by(&:downloaded_at).each do |day, day_msgs|
      day_msgs.group_by(&:project).each do |project, project_msgs|
        @message_downloads << OpenStruct.new(day: day,
                                             project: project,
                                             messages: project_msgs.count)
      end
    end
  end

  # GET /projects/download_messages
  # params = { date: "2012-10-14" }
  def download_messages
    date = params[:date].to_date
    @project = Project.find(params[:id])
    messages_file = @project.messages_as_text_from(date)
    send_data messages_file, filename: "messages_#{date}.txt"
  end
end
