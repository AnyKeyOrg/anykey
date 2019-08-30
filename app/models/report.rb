class Report < ApplicationRecord
  
  IMAGE_STYLES = {
     thumb:     { resize: "120x120",  size: "120x120" }
   }.freeze
  
   validates_presence_of    :reported_twitch_name,
                            :incident_stream,
                            :incident_occurred,
                            :timezone,
                            :incident_description,
                            :reporter_email

   validates_format_of      :reporter_email,
                            with: /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]+\z/,
                            if: lambda { |x| x.reporter_email.present? }

   validates                :incident_description,
                            :desired_outcome,
                            length: { maximum: 1000 }
                            
  image_accessor :image

  def image_url(style = :thumb)
    if style == :original
      self.image.remote_url
    else
      process_image(style).url
    end
  end
  
  private
    def process_image(style) 
      self.image.process(:auto_orient).thumb(Report::IMAGE_STYLES[style][:resize])
    end
  
end
