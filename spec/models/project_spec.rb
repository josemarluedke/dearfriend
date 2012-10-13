require 'spec_helper'

describe Project do
  describe "validations" do
    it{ should validate_presence_of :name }
    it{ should validate_presence_of :description }
    it{ should validate_presence_of :image }
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

  describe "#total_messages_to_be_downloaded" do
    subject { Project.make! }

    before do
      subject.stub(:total_messages_sent).and_return(3)
      3.times do |i|
        m = Message.make!
        m.project = subject
        m.volunteer = User.make! unless i == 0
        m.save
      end
    end

    it "is equal to #total_messages_sent minus already downloaded messages" do
      expect(subject.total_messages_to_be_downloaded).to eql(1)
    end
  end
end
