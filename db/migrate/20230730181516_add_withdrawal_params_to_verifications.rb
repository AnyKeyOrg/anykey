class AddWithdrawalParamsToVerifications < ActiveRecord::Migration[6.1]
  def change
    add_column :verifications, :withdrawn_on, :datetime
    add_column :verifications, :withdrawer_id, :integer
  end
end
