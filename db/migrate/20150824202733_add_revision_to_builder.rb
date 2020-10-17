class AddRevisionToBuilder < ActiveRecord::Migration[5.1]
  def change
    add_column :builders, :osbuild, :string
  end
end
