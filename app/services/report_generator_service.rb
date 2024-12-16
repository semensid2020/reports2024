class ReportGeneratorService
  attr_reader :report

  def initialize(report)
    @report = report
  end

  def call
    document = generate_csv
    file = StringIO.new(document)
    file.class.class_eval { attr_accessor :original_filename }
    filename = "report-#{Time.zone.now.month}-for-user-id_#{report.user_id}.csv"

    file.original_filename = filename
    report.report_file.store!(file)
    report.update(report_filename: filename)
    report.save!

    report.report_file
  end

  private

  def generate_csv
    orders = Order.where(user_id: report.user_id)
    orders = orders.where('created_at >= ?', 1.month.ago)

    csv_data = CSV.generate(headers: true) do |csv|
      csv << ["ID", "Amount", "User Id", "Created At"]
      orders.each do |order|
        csv << [order.id, order.amount, order.user_id, order.created_at]
      end
    end

    csv_data
  end
end
