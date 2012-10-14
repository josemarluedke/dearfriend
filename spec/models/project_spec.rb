require 'spec_helper'

describe Project do
  describe "validations" do
    it{ should validate_presence_of :name }
    it{ should validate_presence_of :description }
    it{ should validate_presence_of :image }
  end

  describe "associations" do
    it { should have_many :messages }
    it { should have_many :stories }
  end

  describe "#total_messages_sent" do
    before do
      @project = Project.make!
      user = User.make!
      3.times { Message.make! project: @project, author: user, volunteer: User.make! }
      2.times { Message.make! project: @project, author: user }
    end

    subject { @project }

    it "should return the total messages sent" do
      subject.total_messages_sent.should == 3
    end
  end

  describe "#can_receive_message?" do
    let(:project) { Project.make! goal: 2 }
    before do
      Message.make! confirmed_payment: true, project: project
      Message.make! project: project
    end

    it "should can receive messages" do
      project.can_receive_message?.should == true
    end

    it "not should can receive messages" do
      Message.make! confirmed_payment: true, project: project
      project.can_receive_message?.should == false
    end
  end

  describe "#all_can_receive_messages" do
    let(:project_1) { Project.make! goal: 2 }
    let(:project_2) { Project.make! goal: 2 }
    before do
      2.times { Message.make! confirmed_payment: true, project: project_1 }
      Message.make! project: project_2
    end
    subject { Project.all_can_receive_messages }

    it "should return only projects that I can receive message" do
      subject.should have(1).item
      subject == [project_2]
    end
  end

  describe "#total_messages_to_be_downloaded" do
    subject { Project.make! }

    before do
      subject.stub(:total_messages_sent).and_return(3)
      3.times do |i|
        m = Message.make!
        m.project = subject
        m.confirmed_payment = true
        m.volunteer = User.make! unless i == 0
        m.save
      end
    end

    it "is equal to #total_messages_sent minus already downloaded messages" do
      expect(subject.total_messages_to_be_downloaded).to eql(1)
    end
  end

  describe "#give_messages_to_volunteer" do
    subject { Project.make! }

    it "assigns a volunteer to the given count of messages" do
      3.times do
        subject.messages.make.tap do |m|
          m.confirmed_payment = true
          m.save
        end
      end
      user = User.make!
      subject.give_messages_to_volunteer(user, 2)
      subject.reload
      expect(subject.messages[0].volunteer).to eql(user)
      expect(subject.messages[1].volunteer).to eql(user)
    end

    it "raises InsufficientMessagesToBeSent in case of quantity request is bigger than available" do
      subject.messages.make!
      user = User.make!
      expect { subject.give_messages_to_volunteer(user, 2) }.to raise_error(InsufficientMessagesToBeSent)
    end
  end

  describe "#messages_as_text_from" do
    it "returns messages_as_text from messages that happened in the requested day" do
      expected_msg = Message.make!(project: subject, downloaded_at: "2012-10-14")
      Message.make!(project: subject, downloaded_at: "2012-10-15")
      Message.make!(project: subject, downloaded_at: "2012-10-15")
      Project.any_instance.should_receive(:messages_as_text).with([expected_msg])
      subject.messages_as_text_from("2012-10-14")
    end
  end
end
