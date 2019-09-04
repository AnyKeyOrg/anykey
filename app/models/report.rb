class Report < ApplicationRecord
  
  AVAILABLE_SCOPES = {
    all:        "All",
    dismissed:  "Dismissed",
    warned:     "Warned",
    revoked:    "Revoked",
    unresolved: "Unresolved",
  }.freeze
    
  IMAGE_STYLES = {
     thumb:    { resize: "120x120" },
     preview:  { resize: "240x240" }
   }.freeze
  
   validates_presence_of    :reported_twitch_name,
                            :incident_stream,
                            :incident_occurred,
                            :timezone,
                            :incident_description,
                            :reporter_email

  validates_format_of       :reporter_email,
                            with: /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]+\z/,
                            if: lambda { |x| x.reporter_email.present? }

  validates                 :incident_description,
                            :recommended_response,
                            length: { maximum: 1000 }

  belongs_to :reviewer, class_name: :User, foreign_key: :reviewer_id
                           
  image_accessor :image
  
  scope :dismissed,    lambda { where("#{table_name}.dismissed IS TRUE") }
  scope :warned,       lambda { where("#{table_name}.warned IS TRUE") }
  scope :revoked,      lambda { where("#{table_name}.revoked IS TRUE") }
  scope :unresolved,   lambda { where("#{table_name}.dismissed IS FALSE AND #{table_name}.warned IS FALSE AND #{table_name}.revoked IS FALSE") }



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
