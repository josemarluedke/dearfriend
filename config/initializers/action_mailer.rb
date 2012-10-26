begin
  ActionMailer::Base.smtp_settings = {
  :address        => Setting.mail[:smtp],
  :port           => Setting.mail[:port],
  :authentication => :plain,
  :user_name      => Setting.mail[:username],
  :password       => Setting.mail[:password],
  :domain         => Setting.mail[:domain]
  }
rescue
  nil
end