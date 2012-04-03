class ContactMailer < ActionMailer::Base
  default from: 'feedback@mapbadger.com'

  def wish_email(url, message)
    @url = url
    @message = message
    mail to: 'hello@mapbadger.com', subject: 'I Wish Submission'
  end
end
