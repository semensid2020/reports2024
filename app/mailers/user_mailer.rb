class UserMailer < ApplicationMailer
  default from: 'no-reply@example.com'

  def send_report(user, document, original_filename)
    @user = user
    @document = document
    @original_filename = original_filename
    attachments[@document.original_filename] = File.read(@document.path)

    mail(to: @user.email, subject: 'Your monthly report')
  end
end
