class CreateAffiliates < ActiveRecord::Migration[6.0]
  def change
    create_table :affiliates do |t|
      t.string :name
      t.string :title
      t.string :image_uid
      t.string :website
      t.string :twitch
      t.string :twitter
      t.string :facebook
      t.string :instagram
      t.string :youtube
      t.text :bio

      t.timestamps
    end
  end
end
