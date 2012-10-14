require "spec_helper"

describe UserMailer do
  describe "volunteer_request_mail" do
    let(:user) { mock_model(User, :name => 'Dearfriend', :email => 'dearfriend@dearfriend.cc') }
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
end
