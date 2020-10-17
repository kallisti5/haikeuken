class LintToText < ActiveRecord::Migration[5.1]
  def change
    change_column :recipes, :lint, :text
  end
end
