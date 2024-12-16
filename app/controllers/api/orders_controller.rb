class Api::OrdersController < Api::ApplicationController
  def last_year_by_months
    @sums_by_month = Order.sum_by_month_within_last_year

    render json: @sums_by_month.map { |record| { month: record[:month].strftime('%Y-%m'), total_amount: record[:total_amount].to_f } }
  end
end
