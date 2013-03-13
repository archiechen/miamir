class AddScaleToTask < ActiveRecord::Migration
  def change
    add_column :tasks, :scale, :integer, :default => 0
  end
end
