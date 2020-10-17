class CreateBuilders < ActiveRecord::Migration[5.1]
  def change
    create_table :builders do |t|
      t.integer :architecture_id
      t.string :hostname
      t.string :owner
      t.string :location
      t.timestamp :lastheard
      t.string :token

      t.timestamps
    end
  end
end
