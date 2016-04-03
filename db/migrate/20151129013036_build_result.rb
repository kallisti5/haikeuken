class BuildResult < ActiveRecord::Migration
  def change
    remove_column :builds, :successful
    add_column :builds, :result, :integer
  end
end
