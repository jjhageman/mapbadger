class ContactMailer < ActionMailer::Base
  default from: 'feedback@mapbadger.com'

  def wish_email(url, sender, message)
    @url = url
    @message = message
    @sender = sender
    mail to: 'hello@mapbadger.com', subject: 'I Wish Submission'
  end

  def csv_upload_alert(url)
    @url = url
    mail to: 'admin@mapbadger.com', subject: 'A customer CSV file has been uploaded'
  end

  def csv_processed_alert(company)
    mail to: company.email, subject: 'Your CSV file has been processed'
  end
end
