require 'spec_helper'

describe ProjectsController do
  before do
    sign_in @user = User.make!
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

  describe "POST 'download_messages'" do
    it "renders 'show' view" do
      User.any_instance.stub(:active_volunteer?).and_return(true)
      post :download_messages, id: Project.make!.id, messages_quantity: "2"
      response.should render_template("show")
    end

    it "gives messages to the logged volunteer" do
      User.any_instance.stub(:active_volunteer?).and_return(true)
      Project.any_instance.should_receive(:give_messages_to_volunteer).
        with(@user, "2")
      post :download_messages, id: Project.make!.id, messages_quantity: "2"
    end
  end
end
