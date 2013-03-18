class AddRedmineProjectIdToTeam < ActiveRecord::Migration
  def change
    add_column :teams, :redmine_project_id, :integer
  end
end
