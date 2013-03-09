class AddGravatarToUser < ActiveRecord::Migration
  def change
    add_column :users, :gravatar, :string
  end
end
