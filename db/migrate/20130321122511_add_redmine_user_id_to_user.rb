class AddRedmineUserIdToUser < ActiveRecord::Migration
  def change
    add_column :users, :redmine_user_id, :integer, :default => 0
  end
end
