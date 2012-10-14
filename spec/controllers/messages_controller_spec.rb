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
  before { sign_in @user = User.make! }

  describe "GET 'new'" do
    it "returns http success" do
      get 'new'
      response.should be_success
    end
  end

  describe "POST 'create'" do
    it "renders new page in case of error on saving resource" do
      Message.any_instance.stub(:save).and_return(false)
      post 'create', message: valid_letter_with_project_attributes
      response.should render_template("new")
    end

    it "redirects to select project page if none project is set" do
      sign_in User.make!
      message = Message.make!(author: @user)
      controller.stub(:resource).and_return(message)
      post 'create', message: valid_completed_letter_attributes
      response.should redirect_to(select_project_message_path(message))
    end

    it "redirects to confirm_payment page in case of project set" do
      project = Project.make!
      post 'create', message: valid_completed_letter_attributes.merge(project_id: project.id)
      response.should redirect_to(confirm_payment_message_path(assigns(:message)))
    end
  end

  describe "PUT 'update'" do
    context "with letter_with_project" do
      it "redirects to payment confirmation page" do
        message = Message.make!(author: @user)
        put 'update', id: message.id, message: valid_letter_with_project_attributes
        response.should redirect_to(confirm_payment_message_path(message))
      end
    end

    it "redirects to new message page if refered message it's already paid" do
      Message.any_instance.stub(:paid?).and_return(true)
      message = Message.make!(author: @user)
      get 'confirm_payment', id: message.id
      response.should_not redirect_to(new_message_path)
    end

    it "renders select_project page in case of none project set" do
      Message.any_instance.stub(:letter_with_project?).and_return(false)
      message = Message.make!(author: @user)
      put 'update', id: message.id, message: valid_letter_with_project_attributes
      response.should render_template("select_project")
    end

    it "assigns projects variable" do
      Message.any_instance.stub(:letter_with_project?).and_return(false)
      message = Message.make!(author: @user)
      put 'update', id: message.id, message: valid_letter_with_project_attributes
      expect(assigns(:projects)).to be_a_kind_of(Array)
    end
  end

  describe "GET 'select_project'" do
    it "renders select_project view" do
      get 'select_project', id: Message.make!(author: @user)
      response.should render_template("select_project")
    end

    it "assigns project variable" do
      message = Message.make!(author: @user)
      get 'select_project', id: message.id
      expect(assigns(:projects)).to be_a_kind_of(Array)
    end

    it "assigns message variable" do
      message = Message.make!(author: @user)
      get 'select_project', id: message.id
      expect(assigns(:message)).to be == message
    end

    it "redirects to new message page if refered message it's already paid" do
      Message.any_instance.stub(:paid?).and_return(true)
      message = Message.make!(author: @user)
      get 'confirm_payment', id: message.id
      response.should_not redirect_to(new_message_path)
    end
  end

  describe "GET 'confirm_payment'" do
    it "renders confirm_payment view if its a letter with project" do
      message = Message.make!(author: @user, project: Project.make!)
      get 'confirm_payment', id: message.id
      response.should render_template("confirm_payment")
    end

    it "redirects to select_project action if its a letter without project" do
      message = Message.make!(author: @user)
      Message.any_instance.stub(:letter_with_project?).and_return(false)
      get 'confirm_payment', id: message.id
      response.should redirect_to(select_project_message_path(message))
    end

    it "redirects to new message page if refered message it's already paid" do
      Message.any_instance.stub(:paid?).and_return(true)
      message = Message.make!(author: @user)
      get 'confirm_payment', id: message.id
      response.should_not redirect_to(new_message_path)
    end
  end

  describe "POST 'pay'" do
    let(:message) { Message.make!(author: @user) }

    describe "First request: asking authorization" do
      it "makes a call to payment's setup! method" do
        controller.stub(:payments_success_callback_url).and_return("http://success")
        controller.stub(:payments_cancel_callback_url).and_return("http://cancel")
        Payment.any_instance.stub(:redirect_uri).and_return("http://dearfriend.cc/")

        Payment.any_instance.should_receive(:setup!).with("http://success", "http://cancel").and_return(true)
        post :pay, id: message
      end

      it "updates support's payment_token" do
        Payment.any_instance.stub(:new).and_return(double.as_null_object)
        Payment.any_instance.stub(:token).and_return("big_payment_token")
        Payment.any_instance.stub(:redirect_uri).and_return(root_url)
        post :pay, id: message
        expect(message.reload.payment_token).to be_eql("big_payment_token")
      end
    end
  end
end
