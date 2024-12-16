# == Schema Information
#
# Table name: orders
#
#  id         :bigint           not null, primary key
#  amount     :decimal(12, 2)   not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_orders_on_user_id  (user_id)
#
class Order < ApplicationRecord
  validates :amount, presence: true

  scope :within_last_year, lambda {
    delta = Order.calculate_delta
    where(created_at: (DateTime.now - delta).to_date..)
  }

  # Костылик для високосного года (leap year)
  def self.calculate_delta
    return 365 if Time.zone.today.leap? && Time.zone.now.month < 3
    return 366 if Time.zone.today.leap?
    return 366 if (Time.zone.today - 365).leap? && Time.zone.now.month < 3

    365
  end

  # Можно было использовать гем 'groupdate', тогда бы красиво забиралось orders.group_by_month(..)
  # Но решил собрать запрос вручную. SQL почти идентичный
  def self.sum_by_month_within_last_year
    orders = Order.within_last_year
    orders
      .select("DATE_TRUNC('month', created_at) AS month, SUM(amount) AS total_amount")
      .group("DATE_TRUNC('month', created_at)")
      .order('month DESC')
  end
end
