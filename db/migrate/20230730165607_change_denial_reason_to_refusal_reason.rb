class ChangeDenialReasonToRefusalReason < ActiveRecord::Migration[6.1]
  def change
    rename_column :verifications, :denial_reason, :refusal_reason
  end
end
