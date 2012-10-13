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
end
