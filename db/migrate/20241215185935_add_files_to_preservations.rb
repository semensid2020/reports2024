class AddFilesToPreservations < ActiveRecord::Migration[7.0]
  def change
    add_column :preservations, :initial_file, :string
    add_column :preservations, :name_of_initial_file, :string
    add_column :preservations, :verification_file, :string
    add_column :preservations, :name_of_verification_file, :string
  end
end
