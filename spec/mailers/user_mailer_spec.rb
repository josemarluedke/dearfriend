require "spec_helper"

describe UserMailer do
  let(:user) { mock_model(User, :name => 'Dearfriend', :email => 'dearfriend@dearfriend.cc') }
  
  describe "volunteer_request_mail" do
    let(:mail) { UserMailer.volunteer_request_email(user) }

    #ensure that the subject is correct
    it 'renders the subject' do
      mail.subject.should == "Volunteer request: #{user.name}"
    end

    #ensure that the receiver is correct
    it 'renders the receiver email' do
      mail.to.should include('contact@dearfriend.cc')
    end

    #ensure that the @confirmation_url variable appears in the email body
    it 'assigns @confirmation_url' do
      mail.body.encoded.should match("http://dearfriend.cc/admin")
    end
  end

  describe "volunteer_confirmation_mail" do
    let(:mail_confirmation) { UserMailer.volunteer_confirmation_email(user) }

    #ensure that the subject is correct
    it 'renders the subject' do
      mail_confirmation.subject.should == "You're approved as a Volunteer at Dear Friend!"
    end

    #ensure that the receiver is correct
    it 'renders the receiver email' do
      mail_confirmation.to.should include(user.email)
    end

    #ensure that the @confirmation_url variable appears in the email body
    it 'assigns @confirmation_url' do
      mail_confirmation.body.encoded.should match("http://dearfriend.cc")
    end
  end
end
