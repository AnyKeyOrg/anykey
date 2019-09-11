class Story < ApplicationRecord
  
  IMAGE_STYLES = {
     thumb:    { resize: "240x135#" },
     card:     { resize: "480x270#" }
   }.freeze


  before_validation :set_published_on
  
  validates_presence_of    :headline,
                           :description,
                           :link,
                           :image,
                           :published_on,
                           if: :published?

  attr_accessor :published_on_date, :published_on_time

  image_accessor :image

  scope :published,         lambda { where("#{table_name}.published IS TRUE") }

  def image_url(style = :thumb)
    if style == :original
      self.image.remote_url
    else
      process_image(style).url
    end
  end
  
  def set_published_on
    if published
      if published_on_date && published_on_time
        self.published_on = "#{published_on_date} #{published_on_time}"
      end
    else
      self.published_on = nil
    end
  end
  
  private
    def process_image(style) 
      self.image.process(:auto_orient).thumb(Story::IMAGE_STYLES[style][:resize])
    end

end
