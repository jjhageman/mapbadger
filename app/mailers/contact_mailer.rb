class ContactMailer < ActionMailer::Base
  default from: 'feedback@mapbadger.com'

  def wish_email(url, sender, message)
    @url = url
    @message = message
    @sender = sender
    mail to: 'hello@mapbadger.com', subject: 'I Wish Submission'
  end
end
