require 'spec_helper'

describe ProjectsController do
  before do
    sign_in @user = User.make!(volunteer: true, verified_volunteer: true)
    @project = Project.make!
  end

  describe "GET 'show'" do
    it "returns http success" do
      get :show, id: @project.id
      response.should be_success
    end

    it "should assing @project" do
      get :show, id: @project.id
      assigns(:project).should == @project
    end
  end

  describe "POST 'take_messages'" do
    context "having a project id as params[:id] parameter" do
      it "renders 'show' view when has insufficient messages to be sent by the requested quantity" do
        project = Project.make!
        Message.make!(project: project)
        User.any_instance.stub(:active_volunteer?).and_return(true)
        post :take_messages, id: project.id, messages_quantity: "2"
        response.should render_template("show")
      end

      it "sends a text file with some messages" do
        project = Project.make!
        Message.make!(project: project)
        messages_file = stub("string to represent the text file")
        Project.any_instance.stub(:give_messages_to_volunteer).
          with(@user, "1").and_return(messages_file)
        controller.should_receive(:send_data).with(messages_file, anything).
          and_return { controller.render nothing: true }
        post :take_messages, id: project.id, messages_quantity: "1"
      end

      it "gives messages to the logged volunteer" do
        User.any_instance.stub(:give_messages_to_volunteer)
        Project.any_instance.should_receive(:give_messages_to_volunteer).
          with(@user, "2")
        post :take_messages, id: Project.make!.id, messages_quantity: "2"
      end
    end
  end

  describe "GET 'download_messages'" do
    subject { Project.make! }
    before do
      Message.make!(project: subject, volunteer: @user, downloaded_at: "2012-10-12")
      Message.make!(project: subject, volunteer: @user, downloaded_at: "2012-10-12")
      Message.make!(project: subject, volunteer: @user, downloaded_at: "2012-10-14")
      Message.make!(project: Project.make!, volunteer: @user, downloaded_at: "2012-10-12")
    end

    it "assigns message_downloads with messages grouped by project and download day" do
      get :downloaded_messages
      expect(assigns[:message_downloads]).to have(3).items
    end
  end

  describe "GET 'download_messages'" do
    context "having a day as params[:date] parameter" do
      it "gets a list of messages from that day" do
        Project.any_instance.should_receive(:messages_as_text_from).
          with(Date.parse("2012-10-14")).and_return(stub("text file"))
        get :download_messages, id: Project.make!.id, date: "2012-10-14"
      end
    end
  end
end
