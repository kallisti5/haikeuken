class CreateRecipes < ActiveRecord::Migration[5.1]
  def change
    create_table :recipes do |t|
      t.string :name
      t.string :version
      t.integer :revision
      t.string :filename

      t.timestamps
    end
  end
end
