require 'spec_helper'

describe Story do
  describe "validations" do
    it { should validate_presence_of :kind }
    it { should validate_presence_of :user }
    it { should validate_presence_of :project }
  end

  describe "associations" do
    it { should belong_to :user }
    it { should belong_to :project }
  end

  describe "scopes" do
    describe "#by_downloads" do
      before do
        project = Project.make!
        3.times { Story.create kind: "downloaded_messages", project: project, user: User.make!, download_count: 2 }
        2.times { Story.create kind: "created_message", project: project, user: User.make!, download_count: 2 }
      end

      it "should return only the stories created by download messages" do
        Story.by_downloads.should have(3).items
      end
    end

    describe "#by_messages" do
      before do
        project = Project.make!
        1.times { Story.create kind: "downloaded_messages", project: project, user: User.make!, download_count: 2 }
        2.times { Story.create kind: "created_message", project: project, user: User.make!, download_count: 2 }
      end

      it "should return only the stories created by download messages" do
        Story.by_messages.should have(2).items
      end
    end
  end
end
