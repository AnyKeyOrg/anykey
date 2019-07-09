class Pledge < ApplicationRecord
  
  before_create :set_signed_on
  before_save   :screen_twitch_username
  
  validates_presence_of    :first_name, :last_name, :email
  validates_uniqueness_of  :email, case_sensitive: false
  validates_format_of      :email, with: /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]+\z/


  private
    def set_signed_on
      if !self.signed_on.present?
        self.signed_on = Time.now
      end
    end
    
    def screen_twitch_username
      if twitch_username.blank?
        self.twitch_username = nil
      end
    end
  
end
