class Report < ApplicationRecord
  
  SORT_FILTERS = {
    unresolved: "Unresolved",
    dismissed:  "Dismissed",
    warned:     "Warned",
    revoked:    "Revoked",
    watched:    "Watched",
    all:        "All", 
    spam: "Spam"
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

  # report can be referenced by multiple SpamReports in two different fields
  has_many :spam_reports_as_report1, class_name: "SpamReport", foreign_key: "report1_id"
  has_many :spam_reports_as_report2, class_name: "SpamReport", foreign_key: "report2_id"
                           
  image_accessor :image
  
  # Tracks user agent info for incoming reports
  visitable :ahoy_visit
  
  scope :dismissed,    lambda { where(dismissed: true) }
  scope :warned,       lambda { where(warned: true) }
  scope :revoked,      lambda { where(revoked: true) }
  scope :unresolved,   lambda { where("#{table_name}.dismissed IS FALSE AND #{table_name}.warned IS FALSE AND #{table_name}.revoked IS FALSE AND #{table_name}.spam IS FALSE") }
  scope :watched,      lambda { where(watched: true) }
  scope :search,       lambda { |search| where("lower(reported_twitch_name) LIKE :search OR
                                                lower(reported_twitch_id) LIKE :search OR
                                                lower(reporter_email) LIKE :search OR
                                                lower(reporter_twitch_name) LIKE :search OR
                                                lower(reported_twitch_id) LIKE :search OR
                                                lower(incident_stream) LIKE :search OR
                                                lower(incident_stream_twitch_id) LIKE :search OR
                                                lower(incident_description) LIKE :search",
                                                search: "%#{search.downcase}%") }
  scope :spam,         lambda { where(spam: true) }  
  
  
  def unresolved?
    self.dismissed == false && self.warned == false && self.revoked == false && self.spam == false
  end

  def word_count
    return (self.incident_description + " " + self.recommended_response).gsub(/[^\w\s]/,"").split.count
  end
  
  def reported_pledge
    unless self.reported_twitch_id == nil
      Pledge.find_by(twitch_id: self.reported_twitch_id)
    end
  end
  
  def reporter_pledge
    unless self.reporter_twitch_id == nil
      Pledge.find_by(twitch_id: self.reporter_twitch_id)
    end
  end

  def reporter_salutation_name
    if self.reporter_pledge
      return self.reporter_pledge.first_name
    end
    return self.reporter_email.gsub(/\@.*/,"")
  end
  
  def image_url(style = :thumb)
    if style == :original
      self.image.remote_url
    else
      process_image(style).url
    end
  end
  
  # Return report about the same Twitch ID
  def related_reports
    unless self.reported_twitch_id.blank?
      Report.where.not(id: self.id).where(reported_twitch_id: self.reported_twitch_id)
    end
  end

  def related_spam_reports
    unless self.reported_twitch_id.blank?
  
      # all related SpamReport records
      SpamReport.where("report1_id = ? OR report2_id = ?", self.id, self.id).distinct
    
    end

  end
  
  protected
    def ensure_sane_review
      if (self.dismissed || self.warned || self.revoked || self.spam) && !(self.dismissed ^ self.warned ^ self.revoked ^ self.spam)
        if self.dismissed
          errors.add(:dismissed, "must be the only status flag set")
        end
        if self.warned
          errors.add(:warned, "must be the only status flag set")
        end
        if self.revoked
          errors.add(:revoked, "must be the only status flag set")
        end
        if self.spam
          errors.add(:spam, "must be the only status flag set")
        end
      end
    end
  
  private
    def process_image(style) 
      self.image.process(:auto_orient).thumb(Report::IMAGE_STYLES[style][:resize])
    end
  
end
