class RemoveTimezoneFromReport < ActiveRecord::Migration[6.0]
  def change
    remove_column :reports, :timezone
  end
end
