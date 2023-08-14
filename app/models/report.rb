class Report < ApplicationRecord
  
  SORT_FILTERS = {
    unresolved: "Unresolved",
    dismissed:  "Dismissed",
    warned:     "Warned",
    revoked:    "Revoked",
    watched:    "Watched",
    all:        "All"
  }.freeze
    
  IMAGE_STYLES = {
     thumb:    { resize: "120x120" },
     preview:  { resize: "240x240" }
   }.freeze
  
  validates_presence_of     :reported_twitch_name,
                            :incident_stream,
                            :incident_description,
                            :reporter_email

  validates_format_of       :reporter_email,
                            with: /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]+\z/,
                            if: lambda { |x| x.reporter_email.present? }

  validates                 :incident_description,
                            length: { maximum: 1000 }
                            
  validates                 :recommended_response,
                            length: { maximum: 500 }

  validate                  :ensure_sane_review

  belongs_to :reviewer, class_name: :User, foreign_key: :reviewer_id, optional: true
  
  has_one :conduct_warning

  has_one :revocation
  
  has_many :comments, as: :commentable
                           
  image_accessor :image
  
  scope :dismissed,    lambda { where(dismissed: true) }
  scope :warned,       lambda { where(warned: true) }
  scope :revoked,      lambda { where(revoked: true) }
  scope :unresolved,   lambda { where("#{table_name}.dismissed IS FALSE AND #{table_name}.warned IS FALSE AND #{table_name}.revoked IS FALSE") }
  scope :watched,      lambda { where(watched: true) }
  
  # TODO: add Twitch IDs to search
  scope :search,       lambda { |search| where("lower(reported_twitch_name) LIKE :search OR
                                                lower(reporter_email) LIKE :search OR
                                                lower(incident_description) LIKE :search OR
                                                lower(incident_stream) LIKE :search",
                                                search: "%#{search.downcase}%") }
  
  
  def unresolved?
    self.dismissed == false && self.warned == false && self.revoked == false
  end
  
  def word_count
    return (self.incident_description + " " + self.recommended_response).gsub(/[^\w\s]/,"").split.count
  end
  
  def image_url(style = :thumb)
    if style == :original
      self.image.remote_url
    else
      process_image(style).url
    end
  end
  
  protected
    def ensure_sane_review
      if (self.dismissed || self.warned || self.revoked) && !(self.dismissed ^ self.warned ^ self.revoked)
        if self.dismissed
          errors.add(:dismissed, "must be the only status flag set")
        end
        if self.warned
          errors.add(:warned, "must be the only status flag set")
        end
        if self.revoked
          errors.add(:revoked, "must be the only status flag set")
        end
      end
    end
  
  private
    def process_image(style) 
      self.image.process(:auto_orient).thumb(Report::IMAGE_STYLES[style][:resize])
    end
  
end
