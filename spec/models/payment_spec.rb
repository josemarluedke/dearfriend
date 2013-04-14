# encoding: UTF-8
require 'spec_helper'

describe Payment do
  subject { Payment.new(20.0) }

  it "initializes amount" do
    payment = Payment.new(20.0)
    payment.amount.should eql(20.0)
  end

  it "has description constant messages" do
    expect(Payment::DESCRIPTION).to eql('Apoie um Herói Postal')
  end

  describe "checkout!" do
    it "initializes a Moiper Payment with objects attributes" do
      subject.instance_eval { @amount = 42 }

      Moiper::Payment.should_receive(:new).
        with(hash_including(description: 'Apoie um Herói Postal',
                            price: 42,
                            return_url: 'http://return',
                            notification_url: 'http://notification')).
        and_return(stub.as_null_object)

      subject.checkout!('http://return', 'http://notification')
    end

    it "delegates checkout proccess for Moiper::Payment" do
      Moiper::Payment.any_instance.should_receive(:checkout).
        and_return(stub.as_null_object)
      subject.checkout!('http://return', 'http://notification')
    end

    it "returns Moiper::Payment#checkout response" do
      response = stub.as_null_object
      Moiper::Payment.any_instance.should_receive(:checkout).
        and_return(response)
      expect(
        subject.checkout!('http://return', 'http://notification')
      ).to eql(response)
    end

    context "Moiper checkout" do
      it "gives a value for redirect_uri" do
        Moiper::Payment.any_instance.stub(:checkout).
          and_return(stub(checkout_url: 'http://checkout').as_null_object)
        subject.checkout!('http://return', 'http://notification')
        expect(subject.redirect_uri).to eql('http://checkout')
      end

      it "gives a value for token" do
        Moiper::Payment.any_instance.stub(:checkout).
          and_return(stub(token: 'foo_bar').as_null_object)
        subject.checkout!('http://return', 'http://notification')
        expect(subject.token).to eql('foo_bar')
      end
    end
  end
end
