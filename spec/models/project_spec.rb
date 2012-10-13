require 'spec_helper'

describe Project do
  describe "validations" do
    it{ should validate_presence_of :name }
    it{ should validate_presence_of :description }
  end

  describe "associations" do
    it { should have_many :messages }
  end

  describe "#total_messages_sent" do
    before do
      @project = Project.make!
      user = User.make!
      3.times { Message.make! project: @project, author: user, volunteer: User.make! }
      2.times { Message.make! project: @project, author: user }
    end

    subject { @project }

    it "should return the total messtes sent" do
      subject.total_messages_sent.should == 3
    end
  end
end
