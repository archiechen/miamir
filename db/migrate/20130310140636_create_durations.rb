class CreateDurations < ActiveRecord::Migration
  def change
    create_table :durations do |t|
      t.integer :minutes, :default => 0
      t.integer :task_id
      t.integer :owner_id

      t.timestamps
    end

    add_index :durations, :task_id
    add_index :durations, :owner_id
  end
end
