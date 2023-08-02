class Concern < ApplicationRecord
  
  PLAYER_ID_TYPES = {
    riot:    "Riot ID",
    discord: "Discord Username",
    twitter: "Twitter Handle",
    name:    "Real Name"
  }.freeze
  
  
  validates_presence_of :concerning_player_id,
                        :concerning_player_id_type,
                        :description,
                        :concerned_email
                        
  validates_format_of   :concerned_email,
                        with: /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]+\z/,
                        if: lambda { |x| x.concerned_email.present? }

  validates             :background,
                        length: { maximum: 500 }

  validates             :description,
                        length: { maximum: 1000 }
                       
  validates             :recommended_response,
                        length: { maximum: 500 }


  has_many_attached :screenshots
  
end
