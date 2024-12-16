class ReportConstructorService
  attr_reader :report

  def initialize(report)
    @report = report
  end

  def call
    document_created = ReportGeneratorService.new(report).call

    if document_created
    ReportSenderJob.set(wait: 5.seconds).perform_later(document_created.model)
    else
      #
    end
  end
end
