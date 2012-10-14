require 'spec_helper'

describe Payment do
  it "initializes amount" do
    payment = Payment.new(20.0)
    payment.amount.should eql(20.0)
  end

  it "has description constant messages" do
    Payment::DESCRIPTION[:item].should eql("Support a Dear Friend")
    Payment::DESCRIPTION[:payment].should eql("Dear Friend")
  end

  describe "#setup!" do
    subject { Payment.new(20.0) }

    it "makes a call to a client setup method" do
      client = double.as_null_object
      client.should_receive(:setup).
        with(anything, "http://success", "http://cancel", pay_on_paypal: true, no_shipping: true).and_return(double.as_null_object)
      subject.setup!("http://success", "http://cancel", client)
    end

    it "assigns response token" do
      client = double.as_null_object
      client.stub(:setup).and_return(double.as_null_object)
      client.stub_chain(:setup, :token).and_return("xxx")
      subject.setup!("http://success", "http://cancel", client)
      subject.token.should eql("xxx")
    end

    it "logs the transaction" do
      logger = double
      logger.should_receive(:debug).with(/Payment#setup! from/)
      subject = Payment.new(20.0, logger)

      client = double.as_null_object
      client.stub(:setup).and_return(double.as_null_object)
      subject.setup!("http://success", "http://cancel", client)
    end

    it "assigns redirect_uri" do
      client = double.as_null_object
      client.stub_chain(setup: double.as_null_object)
      client.stub_chain(:setup, :redirect_uri).and_return(double.as_null_object)
      subject.setup!("http://success", "http://cancel", client)
    end
  end
end
