ActionMailer::Base.smtp_settings = {
  :user_name => "jjhageman",
  :password => "old2flav",
  :domain => "mapbadger.com",
  :address => "smtp.sendgrid.net",
  :port => 587,
  :authentication => :plain,
  :enable_starttls_auto => true
}
