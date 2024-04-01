class AddSpamToReports < ActiveRecord::Migration[6.1]
  def change
    add_column :reports, :spam, :boolean, default: false
  end
end
