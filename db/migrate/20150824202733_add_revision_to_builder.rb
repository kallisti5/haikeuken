class AddRevisionToBuilder < ActiveRecord::Migration
  def change
    add_column :builders, :osbuild, :string
  end
end
