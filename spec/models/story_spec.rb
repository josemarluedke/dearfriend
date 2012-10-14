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
end
