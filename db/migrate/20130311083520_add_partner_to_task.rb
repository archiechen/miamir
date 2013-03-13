class AddPartnerToTask < ActiveRecord::Migration
  def change
    add_column :tasks, :partner_id, :integer

    add_index :tasks, :partner_id
  end
end
