class LintConsolidation < ActiveRecord::Migration
  def change
	add_column :recipes, :lint, :string
	drop_table :lints
  end
end
