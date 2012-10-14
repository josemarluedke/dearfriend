begin
  ActionMailer::Base.smtp_settings = {
  :address        => 'smtp.mandrillapp.com',
  :port           => '587',
  :authentication => :plain,
  :user_name      => 'contact@dearfriend.cc',
  :password       => 'e2834bd7-e1b4-4402-aefa-5f13af68d72d',
  :domain         => 'dearfriend.cc'
  }
  ActionMailer::Base.delivery_method = :smtp
rescue
  nil
end