class SetPrecisionForRevokedOn < ActiveRecord::Migration[6.0]
  def change
    change_column :pledges, :revoked_on, :datetime, precision: 0    
  end
end
