class AddDenialReasonToVerification < ActiveRecord::Migration[6.1]
  def change
    add_column :verifications, :denial_reason, :text
  end
end
