class CreateRepos < ActiveRecord::Migration[5.1]
  def change
    create_table :repos do |t|
      t.string :name
      t.string :url
      t.timestamp :lastrefresh

      t.timestamps
    end
  end
end
