class AddCategoryToRecipes < ActiveRecord::Migration
  def change
    add_column :recipes, :category, :string
  end
end
