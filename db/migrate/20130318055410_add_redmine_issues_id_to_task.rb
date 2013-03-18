class AddRedmineIssuesIdToTask < ActiveRecord::Migration
  def change
    add_column :tasks, :redmine_issue_id, :integer
  end
end
