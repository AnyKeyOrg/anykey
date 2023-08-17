class BadgeActivation < ApplicationRecord

  validates_presence_of :twitch_username,
                        :twitch_id
                        
  belongs_to :activator, class_name: :User, foreign_key: :activator_id

end
