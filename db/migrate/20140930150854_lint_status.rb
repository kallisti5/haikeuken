class LintStatus < ActiveRecord::Migration[5.1]
  def change
    add_column :recipes, :lintret, :integer
  end
end
