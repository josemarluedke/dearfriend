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

  describe "#complete_letter?" do
    it "returns true if has a letter, from_address and to_address" do
      subject.letter = "Cum augue? Augue pellentesque tristique ac adipiscing ut, montes placerat et, nec tortor mid montes"
      subject.from_address = "Porto Alegre"
      subject.to_address = "São Paulo"
      expect(subject).to be_complete_letter
    end

    it "returns false if has blank letter, from_address or to_address" do
      subject.letter = ""
      subject.from_address = "Porto Alegre"
      subject.to_address = "São Paulo"
      expect(subject).to_not be_complete_letter

      subject.letter = "Cum augue? Augue pellentesque tristique ac adipiscing ut, montes placerat et, nec tortor mid montes"
      subject.from_address = ""
      subject.to_address = "São Paulo"
      expect(subject).to_not be_complete_letter

      subject.letter = "Cum augue? Augue pellentesque tristique ac adipiscing ut, montes placerat et, nec tortor mid montes"
      subject.from_address = "Porto Alegre"
      subject.to_address = ""
      expect(subject).to_not be_complete_letter
    end
  end

  describe "#letter_with_project?" do
    it "returns true if it's a complete_letter and has a project associated" do
      subject.stub(:complete_letter?).and_return(true)
      subject.project = Project.make!
      expect(subject).to be_a_letter_with_project
    end

    it "returns false if it's not a complete_letter but has a project associated" do
      subject.stub(:complete_letter?).and_return(false)
      subject.project = Project.make!
      expect(subject).to_not be_a_letter_with_project
    end

    it "returns false if it's a complete_letter but not has a project associated" do
      subject.stub(:complete_letter?).and_return(true)
      subject.project = nil
      expect(subject).to_not be_a_letter_with_project
    end
  end
end
