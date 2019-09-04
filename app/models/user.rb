class User < ApplicationRecord
  
  IMAGE_STYLES = {
     tiny:      { resize: "28x28#" },
     thumb:     { resize: "120x120#" }
   }.freeze
  
  # Include selected devise modules. Others available are:
  # :confirmable, :lockable, :omniauthable, :registerable abd :timeoutable
  devise :invitable, :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable
  
  has_many :reviewed_reports, class_name: :Report, foreign_key: :reviewer_id
  
  image_accessor :image

  def image_url(style = :thumb)
    if style == :original
      self.image.remote_url
    else
      process_image(style).url
    end
  end
          
  def gravatar_url
    hash = Digest::MD5.hexdigest(self.email.to_s.strip.downcase)
    "https://www.gravatar.com/avatar/#{hash}.png?s=200"
  end
  
  def display_name
    if !self.username.blank?
      return self.username
    elsif !self.friendo_name.blank?
      return self.friendo_name
    else
      return self.email
    end
  end
  
  def friendo_name
    if !self.first_name.blank? && !self.last_name.blank?
      return self.first_name + ' ' + self.last_name.first + '.'
    elsif !self.first_name.blank?
      return self.first_name
    elsif !self.last_name.blank?
      return 'Mx. ' + self.last_name.first + '.'
    else
      return nil
    end
  end
  
  private
    def process_image(style)
      self.image.process(:auto_orient).thumb(User::IMAGE_STYLES[style][:resize])
    end
         
end
