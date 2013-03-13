class AddPartnerToDuration < ActiveRecord::Migration
  def change
    add_column :durations, :partner_id, :integer

    add_index :durations, :partner_id
  end
end
