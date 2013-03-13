class AddEstimateToTask < ActiveRecord::Migration
  def change
    add_column :tasks, :estimate, :integer, :default => 0
  end
end
