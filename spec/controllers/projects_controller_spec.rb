require 'spec_helper'

describe ProjectsController do
  before do
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
end
