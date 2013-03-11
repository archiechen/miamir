class AddPartnerToTask < ActiveRecord::Migration
  def change
    add_column :tasks, :partner_id, :integer
  end
end
