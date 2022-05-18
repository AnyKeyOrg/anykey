class AddTimesWarnedToPledges < ActiveRecord::Migration[6.0]
  def change
    add_column :pledges, :times_warned, :integer, default: 0
    add_column :pledges, :last_warned_on, :datetime
  end
end
