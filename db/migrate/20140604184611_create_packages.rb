class CreatePackages < ActiveRecord::Migration[5.1]
  def change
    create_table :packages do |t|
      t.integer :recipe_id
      t.integer :repo_id
      t.integer :architecture_id
      t.integer :latestrev
      t.string :path

      t.timestamps
    end
  end
end
