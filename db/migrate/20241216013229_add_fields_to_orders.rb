class AddFieldsToOrders < ActiveRecord::Migration[7.0]
  def change
    add_column :orders, :user_id, :bigint, null: false

    add_index :orders, :user_id
  end
end
