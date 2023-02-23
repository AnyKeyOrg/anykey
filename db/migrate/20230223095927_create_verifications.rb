class CreateVerifications < ActiveRecord::Migration[6.1]
  def change
    create_table :verifications do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :discord_username
      t.string :player_id_type
      t.string :player_id
      t.string :gender
      t.string :pronouns
      t.string :social_profile
      t.text :additional_notes
      t.boolean :voice_requested
      t.string :status
      t.datetime :requested_on
      t.datetime :reviewed_on
      t.integer :reviewer_id
      t.timestamps
    end
  end
end
