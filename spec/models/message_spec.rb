# encoding: UTF-8
require 'spec_helper'

describe Message do
  describe "validations" do
    it{ should validate_presence_of :letter }
    it{ should validate_presence_of :author }
    it{ should validate_presence_of :from_address }
    it{ should validate_presence_of :to_address }
  end

  describe "associations" do
    it { should belong_to :author }
    it { should belong_to :project }
    it { should belong_to :volunteer }
  end

  describe "scopes" do
    describe "sent" do
      it "includes messages with a volunteer assigned" do
        with_volunteer = Message.make!(volunteer: User.make!(volunteer: true))
        expect(Message.sent).to include(with_volunteer)
      end

      it "excludes messages without a volunteer assigned" do
        without_volunteer = Message.make!(volunteer: nil)
        expect(Message.sent).to_not include(without_volunteer)
      end
    end

    describe "paid_messages" do
      it "includes messages with a confirmed payment" do
        confirmed = Message.make!(confirmed_payment: true)
        expect(Message.paid_messages).to include(confirmed)
      end

      it "excludes messages without a confirmed payment" do
        without_payment = Message.make!(confirmed_payment: false)
        expect(Message.paid_messages).to_not include(without_payment)
      end
    end

    describe "to_be_sent" do
      before do
        2.times do
          Message.make(volunteer: nil).tap do |m|
            m.confirmed_payment = true
            m.save
          end
        end
        Message.make!(volunteer: nil)
      end

      it "gets just paid messages and with volunteers" do
        expect(Message.to_be_sent).to have(2).items
      end
    end
  end

  describe "#letter_with_project?" do
    it "returns true if it's valid and has a project associated" do
      subject.stub(:valid?).and_return(true)
      subject.project = Project.make!
      expect(subject).to be_a_letter_with_project
    end

    it "returns false if it's not valid and has a project associated" do
      subject.stub(:valid?).and_return(false)
      subject.project = Project.make!
      expect(subject).to_not be_a_letter_with_project
    end

    it "returns false if it's valid but not has a project associated" do
      subject.stub(:valid?).and_return(false)
      subject.project = nil
      expect(subject).to_not be_a_letter_with_project
    end
  end

  describe "#paid?" do
    it "returns true if it has a confirmed payment" do
      message = Message.make!(confirmed_payment: true)
      message.should be_paid
    end

    it "returns false if it has no confirmed payments" do
      message = Message.make!(confirmed_payment: false)
      message.should_not be_paid
    end
  end

  describe "story" do
    subject { Message.make! project: Project.make! }

    describe "not confirmed payment" do
      it "should not have a story" do
        subject.project.stories.by_messages be_empty
      end
    end

    describe "confirmed payment" do
      before do
        subject.confirm! "12345"
      end

      it "should create a story on confirm payment" do
        subject.project.stories.by_messages.should have(1).tem
      end

      it "should set a correct kind of story" do
        story = subject.project.stories.by_messages.first
        story.kind.should == "created_message"
      end

      it "should set a correct author of story" do
        story = subject.project.stories.by_messages.first
        story.user.should == subject.author
      end
    end
  end
end
