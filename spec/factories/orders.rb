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
FactoryBot.define do
  factory :order do
    amount { 1000.00 }
    user
    created_at { Time.zone.now }
  end
end
