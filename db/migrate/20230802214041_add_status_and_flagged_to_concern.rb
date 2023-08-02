class AddStatusAndFlaggedToConcern < ActiveRecord::Migration[6.1]
  def change
    add_column :concerns, :status, :string
    add_column :concerns, :flagged, :boolean, default: false
  end
end
