class LintToText < ActiveRecord::Migration
  def change
	change_column :recipes, :lint, :text
  end
end
