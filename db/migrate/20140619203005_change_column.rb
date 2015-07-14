class ChangeColumn < ActiveRecord::Migration
  def change
    change_column :lints, :result, :text
  end
end
