class BuildCleanup < ActiveRecord::Migration[5.1]
  def change
    remove_column :builds, :status
    add_column :builds, :successful, :boolean
    rename_column :builds, :result, :details
    add_column :builds, :asset_id, :integer
  end
end
