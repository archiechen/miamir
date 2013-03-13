class AddStatusToTask < ActiveRecord::Migration
  def change
    add_column :tasks, :status, :string
    add_index  :tasks, :status
  end
end
