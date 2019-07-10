class AddIdentifierToPledge < ActiveRecord::Migration[6.0]
  def change
    add_column :pledges, :identifier, :string
  end
end
