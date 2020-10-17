class CreateArchitectures < ActiveRecord::Migration[5.1]
  def change
    create_table :architectures do |t|
      t.string :name

      t.timestamps
    end
  end
end
