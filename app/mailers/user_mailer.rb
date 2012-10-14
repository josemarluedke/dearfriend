class UserMailer < ActionMailer::Base
  default from: "contact@dearfriend.cc", to: "contact@dearfriend.cc"


  def volunteer_request_email(user)
    @user = user
    mail(:subject => "Volunteer request: #{@user.name}")
  end

  def volunteer_confirmation_email(user)
    @user = user
    mail(to: @user.email, :subject => "You're approved as a Volunteer at Dear Friend!")
  end
end
