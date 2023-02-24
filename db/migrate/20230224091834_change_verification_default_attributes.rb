class ChangeVerificationDefaultAttributes < ActiveRecord::Migration[6.1]
  def change
    change_column :verifications, :voice_requested, :boolean, default: false
  end
end
