class AddRedmineKeyToUser < ActiveRecord::Migration
  def change
    add_column :users, :redmine_key, :string
  end
end
