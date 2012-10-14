require 'spec_helper'

describe PaymentsController do
  let(:user) { User.make! }
  let(:project) { Project.make! }
  let(:message) { Message.make!(author: user, project: project) }

  before { sign_in user }

  describe "First request: asking authorization" do
    it "makes a call to payment's setup! method" do
      controller.stub(:success_callback_payment_url).and_return("http://success")
      controller.stub(:cancel_callback_payment_url).and_return("http://cancel")
      Payment.any_instance.stub(:redirect_uri).and_return("http://dearfriend.cc/")

      Payment.any_instance.should_receive(:setup!).with("http://success", "http://cancel").and_return(true)
      post :create, message_id: message
    end

    it "updates support's payment_token" do
      Payment.any_instance.stub(:new).and_return(double.as_null_object)
      Payment.any_instance.stub(:token).and_return("big_payment_token")
      Payment.any_instance.stub(:redirect_uri).and_return(root_url)
      post :create, message_id: message
      expect(message.reload.payment_token).to be_eql("big_payment_token")
    end

  end

  describe "Second request: taking the money" do
    describe "with valid params" do
      it "makes a call to payment's complete! method" do
        Payment.any_instance.should_receive(:complete!)
        get :success_callback, PayerID: user.id.to_s, token: message.payment_token, project_id: message.project_id
      end

      it "sets support's transaction_id" do
        Payment.any_instance.stub(:complete!)
        Payment.any_instance.stub(:identifier).and_return("identification")
        get :success_callback, PayerID: user.id.to_s, token: message.payment_token, project_id: message.project_id
        message.reload
        message.transaction_id.should eql("identification")
      end

      it "sets message as confirmed" do
        Payment.any_instance.stub(:complete!)
        get :success_callback, PayerID: user.id.to_s, token: message.payment_token, project_id: message.project_id
        expect(message.reload).to be_paid
      end
    end

    describe "with invalid payer_id" do
      it "not sets support as confirmed" do
        Payment.any_instance.stub(:complete!)
        message.should_not_receive(:confirm!)
        get :success_callback, PayerID: "invalid", token: message.payment_token, project_id: message.project_id
      end
    end
  end
end
