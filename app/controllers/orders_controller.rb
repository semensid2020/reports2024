class OrdersController < ApplicationController
  before_action :authenticate_user!

  def index
    @orders = Order.order(created_at: :desc)
  end

  def within_last_year
    @orders = Order.within_last_year.order(created_at: :desc)
  end
end
