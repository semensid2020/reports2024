class CreateReports < ActiveRecord::Migration[7.0]
  def change
    create_table :reports do |t|
      t.references :user,  null: false, foreign_key: true
      t.integer    :month, null: false
      t.string     :report_file
      t.string     :report_filename

      t.timestamps
    end
  end
end
