class AddReferralsCountToPledge < ActiveRecord::Migration[6.0]
  def change
    add_column :pledges, :referrals_count, :integer, default: 0
  end
end
