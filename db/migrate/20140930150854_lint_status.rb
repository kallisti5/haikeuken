class LintStatus < ActiveRecord::Migration
  def change
    add_column :recipes, :lintret, :integer
  end
end
