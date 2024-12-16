class MailSenderService
  attr_reader :document, :user, :report

  def initialize(document)
    @report = report
    @document = report.report_file
    @user = document.model.user
  end

  def call
    UserMailer.send_report(user, document, report.report_filename).deliver_now
  end
end
