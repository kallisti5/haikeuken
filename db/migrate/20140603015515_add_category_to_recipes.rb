class AddCategoryToRecipes < ActiveRecord::Migration[5.1]
  def change
    add_column :recipes, :category, :string
  end
end
