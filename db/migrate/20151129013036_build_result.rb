class BuildResult < ActiveRecord::Migration[5.1]
  def change
    remove_column :builds, :successful
    add_column :builds, :result, :integer
  end
end
