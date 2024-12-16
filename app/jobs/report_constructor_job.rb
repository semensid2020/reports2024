class ReportConstructorJob < ApplicationJob
  queue_as :default

  def perform(report)
    ReportConstructorService.new(report).call
  end
end
