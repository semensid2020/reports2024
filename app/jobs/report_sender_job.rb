class ReportSenderJob < ApplicationJob
  queue_as :mailers

  def perform(report)
    MailSenderService.call(report)
  end
end
