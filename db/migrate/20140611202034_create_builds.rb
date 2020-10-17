class CreateBuilds < ActiveRecord::Migration[5.1]
  def change
    create_table :builds do |t|
      t.integer :architecture_id
      t.integer :builder_id
      t.integer :recipe_id
      t.timestamp :issued
      t.timestamp :completed
      t.text :result

      t.timestamps
    end
  end
end
