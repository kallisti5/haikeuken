class LintConsolidation < ActiveRecord::Migration
  def change
    add_column :recipes, :lint, :string
  end
end
