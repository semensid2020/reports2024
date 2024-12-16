# == Schema Information
#
# Table name: orders
#
#  id         :bigint           not null, primary key
#  amount     :decimal(12, 2)   not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :order do
    amount { 1000.00 }
    created_at { Time.zone.now }
  end
end
