class CreateBurnings < ActiveRecord::Migration
  def change
    create_table :burnings do |t|
      t.integer :burning
      t.integer :remain
      t.integer :team_id

      t.timestamps
    end
  end
end
