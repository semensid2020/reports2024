class CreatePreservations < ActiveRecord::Migration[7.0]
  def change
    create_table :preservations do |t|
      t.integer :status, null: false, default: 0
      t.string :initial_file_link, null: false
      t.string :preserved_file_link
      # Временно будем писать сюда какие-то логи, не знаю надо ли оставлять по итогу эту колонку
      t.text :logs

      t.timestamps
    end
  end
end
