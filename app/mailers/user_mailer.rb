class UserMailer < ActionMailer::Base
  default from: "contact@dearfriend.cc", to: "contact@dearfriend.cc"


  def volunteer_request_email(user)
    @user = user
    mail(:subject => "Volunteer request: #{@user.name}")
  end
end
