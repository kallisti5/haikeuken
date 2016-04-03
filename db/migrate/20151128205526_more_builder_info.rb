class MoreBuilderInfo < ActiveRecord::Migration
  def change
    add_column :builders, :threads, :integer
    add_column :builders, :client_version, :string
  end
end
