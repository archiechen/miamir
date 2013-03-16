class AddPriorityToTask < ActiveRecord::Migration
  def change
    add_column :tasks, :priority, :integer, :default => 50
  end
end
