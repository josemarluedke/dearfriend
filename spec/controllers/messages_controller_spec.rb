require 'spec_helper'

def valid_completed_letter_attributes
  {
    letter: "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
    from_address: "221B Baker Street",
    to_address: "220B Baker Street"
  }
end

def valid_letter_with_project_attributes
  {
    project_id: Project.make!.id
  }
end

describe MessagesController do

  describe "GET 'new'" do
    it "returns http success" do
      get 'new'
      response.should be_success
    end
  end

  describe "POST 'create'" do
    it "redirects to select project page" do
      sign_in User.make!
      message = Message.make!
      controller.stub(:resource).and_return(message)
      post 'create', message: valid_completed_letter_attributes
      response.should redirect_to(select_project_message_path(message))
    end

    it "renders new page in case of none project set" do
      Message.any_instance.stub(:save).and_return(false)
      post 'new', message: valid_letter_with_project_attributes
      response.should render_template("new")
    end
  end

  describe "PUT 'update'" do
    context "with letter_with_project" do
      it "redirects to payment confirmation page" do
        message = Message.make!
        put 'update', id: message.id, message: valid_letter_with_project_attributes
        response.should redirect_to(confirm_payment_message_path(message))
      end

      it "renders select_project page in case of none project set" do
        Message.any_instance.stub(:letter_with_project?).and_return(false)
        message = Message.make!
        put 'update', id: message.id, message: valid_letter_with_project_attributes
        response.should render_template("select_project")
      end
    end

    it "redirects to new message page if refered message it's already paid" do
      Message.any_instance.stub(:paid?).and_return(true)
      message = Message.make!
      put 'update', id: message.id, message: valid_letter_with_project_attributes
      response.should redirect_to(new_message_path)
      expect(flash[:warning]).to eql("You already completed this letter. What about writing another one?")
    end
  end

  describe "GET 'select_project'" do
    it "renders select_project view" do
      get 'select_project', id: Message.make!
      response.should render_template("select_project")
    end

    it "assigns project variable" do
      message = Message.make!
      get 'select_project', id: message.id
      expect(assigns(:projects)).to be_a_kind_of(Array)
    end

    it "assigns message variable" do
      message = Message.make!
      get 'select_project', id: message.id
      expect(assigns(:message)).to be == message
    end

    it "redirects to new message page if refered message it's already paid" do
      Message.any_instance.stub(:paid?).and_return(true)
      message = Message.make!
      get 'select_project', id: message.id
      response.should redirect_to(new_message_path)
      expect(flash[:warning]).to eql("You already completed this letter. What about writing another one?")
    end
  end

  describe "GET 'confirm_payment'" do
    it "renders confirm_payment view if its a letter with project" do
      message = Message.make!
      Message.any_instance.stub(:letter_with_project?).and_return(true)
      get 'confirm_payment', id: message.id
      response.should render_template("confirm_payment")
    end

    it "redirects to select_project action if its a letter without project" do
      message = Message.make!
      Message.any_instance.stub(:letter_with_project?).and_return(false)
      get 'confirm_payment', id: message.id
      response.should redirect_to(select_project_message_path(message))
    end

    it "redirects to new message page if refered message it's already paid" do
      Message.any_instance.stub(:paid?).and_return(true)
      message = Message.make!
      get 'confirm_payment', id: message.id
      response.should redirect_to(new_message_path)
      expect(flash[:warning]).to eql("You already completed this letter. What about writing another one?")
    end
  end
end
