class CreateAccumulations < ActiveRecord::Migration
  def change
    create_table :accumulations do |t|
      t.string :status
      t.integer :team_id
      t.integer :amount

      t.timestamps
    end
  end
end
