class ContactMailer < ActionMailer::Base
  default from: 'feedback@mapbadger.com'

  def wish_email(url, message)
    @url = url
    @message = message
    @sender = current_company.try(:email)
    mail to: 'hello@mapbadger.com', subject: 'I Wish Submission'
  end
end
