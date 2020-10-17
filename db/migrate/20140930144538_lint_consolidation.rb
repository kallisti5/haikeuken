class LintConsolidation < ActiveRecord::Migration[5.1]
  def change
    add_column :recipes, :lint, :string
  end
end
