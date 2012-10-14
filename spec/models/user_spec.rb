require 'spec_helper'
require "cancan/matchers"

describe User do
  before do
    @user = User.make!
  end

  it "should valid" do
    @user.should be_valid
  end

  describe "password required?" do
    context "news users" do
      before do
        @user = User.new
      end

      it "requires a password" do
        @user.should be_password_required
      end

      it "should require password & match confirmation" do
        @user.password = nil
        @user.password_confirmation = nil
        @user.should_not be_valid

        @user.password = "Josemar"
        @user.password_confirmation = nil
        @user.should_not be_valid

        @user.password = "Josemar"
        @user.password_confirmation = "Luedke"
        @user.should_not be_valid
      end
    end

    context "existing user" do
      before do
        @user.save!
        @user = User.find @user.id
        end

      it "requires a password when password is present" do
        @user.password = 'josemar'
        @user.should be_password_required
      end

      it "requires a correct password when password_comfirmation is present" do
        @user.password_confirmation = 'xx'
        @user.should be_password_required
      end

      it "should not require password no password or confirmation is present" do
        @user.reload.should_not be_password_required
      end

      it "shoult not be required password" do
        @user.password = nil
        @user.password_confirmation = nil
        @user.should be_valid
      end
    end
  end

  describe "validations" do
    subject { @user }

    it{ should validate_presence_of :name }
    it{ should validate_presence_of :email }
    it{ should validate_presence_of :password }
  end

  describe "associations" do
    it { should have_many :authorizations }
    it { should have_many :messages_as_author }
    it { should have_many :messages_as_volunteer }
  end

  describe "abilities" do
    subject { ability }
    let(:ability) { Ability.new(user) }
    let(:user) { User.make! }

    it "manages its own messages" do
      message = Message.new
      message.author = user
      should be_able_to(:manage, message)
    end

    it "doesn't manages messages from other users" do
      message = Message.new
      message.author = User.make!
      should_not be_able_to(:manage, message)
    end

    it "doesn't pays messages from others users" do
      message = Message.make!
      message.stub(:paid?).and_return(true)
      message.author = User.make!
      should_not be_able_to(:pay, message)
    end

    it "pays messages don't paid yet" do
      message = Message.make!
      message.stub(:paid?).and_return(false)
      message.author = user
      should be_able_to(:pay, message)
    end

    it "doesn't pays messages already paid" do
      message = Message.make!(author: user)
      message.stub(:confirmed_payment).and_return(true)
      should_not be_able_to(:pay, message)
    end

    it "doesn't download messages" do
      should_not be_able_to(:download_messages, Project.new)
    end

    context "volunteers" do
      let(:user) do
        user = User.make!
        user.stub(:active_volunteer?).and_return(true)
        user
      end

      it "does download project's messages" do
        should be_able_to(:download_messages, Project.new)
        should be_able_to(:take_messages, Project.new)
      end

      it "does access it's own history of message downloads" do
        should be_able_to(:download_messages, Project.new)
      end
    end
  end

  describe "#active_volunteer?" do
    before do
      @user = User.make!
      @volunteer = User.make! volunteer: true
      @verified_volunteer = User.make! volunteer: true, verified_volunteer: true
    end

    describe "User" do
      it "should not be a valid volunteer" do
        @user.should_not be_active_volunteer
      end
    end

    describe "Volunteer" do
      it "should not be a active_volunteer" do
        @volunteer.should_not be_active_volunteer
      end
    end

    describe "Verified Volunteer" do
      it "should be a valid volunteer" do
        @verified_volunteer.should be_active_volunteer
      end
    end
  end

  describe "#email" do
    before do
      @user = User.make!
    end

    it "sends a volunteer request e-mail" do
      @user.volunteer = true
      UserMailer.should_receive(:volunteer_request_email)
      @user.save
    end

    it "sends a volunteer confirmation e-mail" do
      @user.verified_volunteer = true
      UserMailer.should_receive(:volunteer_confirmation_email)
      @user.save
    end
  end
end
