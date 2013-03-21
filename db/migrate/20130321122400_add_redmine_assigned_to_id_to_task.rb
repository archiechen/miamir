class AddRedmineAssignedToIdToTask < ActiveRecord::Migration
  def change
    add_column :tasks, :redmine_assigned_to_id, :integer, :default => 0
  end
end
