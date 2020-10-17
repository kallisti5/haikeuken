class AddActiveToBuild < ActiveRecord::Migration[5.1]
  def change
    add_column :builds, :active, :boolean
  end
end
