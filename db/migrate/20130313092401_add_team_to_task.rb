class AddTeamToTask < ActiveRecord::Migration
  def change
    add_column :tasks, :team_id, :integer

    add_index :tasks, :team_id
  end
end
