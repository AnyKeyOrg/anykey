class AddReferrerToPledge < ActiveRecord::Migration[6.0]
  def change
    add_column :pledges, :referrer_id, :integer
  end
end
