class AddActiveToBuild < ActiveRecord::Migration
  def change
    add_column :builds, :active, :boolean
  end
end
