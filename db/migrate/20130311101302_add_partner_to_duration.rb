class AddPartnerToDuration < ActiveRecord::Migration
  def change
    add_column :durations, :partner_id, :integer
  end
end
