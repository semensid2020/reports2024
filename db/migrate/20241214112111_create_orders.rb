class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :orders do |t|
      t.decimal :amount, null: false, precision: 12, scale: 2

      t.timestamps
    end
  end
end
