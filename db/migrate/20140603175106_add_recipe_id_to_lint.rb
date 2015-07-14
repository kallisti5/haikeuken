class AddRecipeIdToLint < ActiveRecord::Migration
  def change
    add_column :lints, :recipe_id, :integer
  end
end
