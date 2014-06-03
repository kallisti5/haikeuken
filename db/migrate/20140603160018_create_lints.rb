class CreateLints < ActiveRecord::Migration
  def change
    create_table :lints do |t|
      t.boolean :clean
      t.string :result

      t.timestamps
    end
  end
end
