class Pledge < ApplicationRecord
  
  before_create :set_signed_on
  
  validates_presence_of    :first_name, :last_name, :email
  validates_uniqueness_of  :email, case_sensitive: false
  validates_format_of      :email, with: /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]+\z/


  private
    def set_signed_on
      if !self.signed_on.present?
        self.signed_on = Time.now
      end
    end
  
end
