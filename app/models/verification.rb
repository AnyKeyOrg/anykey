class Verification < ApplicationRecord
  
  require 'csv'
  require 'uri'
  
  STATUSES = {
    pending:   "Pending",
    ignored:   "Ignored",
    denied:    "Denied",
    withdrawn: "Withdrawn",
    eligible:  "Eligible"
  }.freeze
  
  SORT_FILTERS = {
    pending:          "Pending",
    voice_requested:  "Voice",
    ignored:          "Ignored",
    denied:           "Denied",
    withdrawn:        "Withdrawn",
    eligible:         "Eligible",
    watched:          "Watched",    
    all:              "All"
  }.freeze
  
  PLAYER_ID_TYPES = {
    blizzard: "Blizzard BattleTag",
    ea:       "EA (Electronic Arts) ID",
    epic:     "Epic Games Display Name",
    riot:     "Riot ID",
    steam:    "Steam Profile Name"
  }.freeze

  before_create :ensure_requested_on_set
  before_create :ensure_status_set
  before_create :flag_attachment_submission
    
  validates_presence_of :first_name,
                        :last_name,
                        :email,
                        :discord_username,
                        :player_id_type,
                        :player_id,
                        :gender,
                        :pronouns
                        
  validates_format_of   :email,
                        with: /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]+\z/,
                        if: lambda { |x| x.email.present? }
  
  validate              :ensure_valid_social_url
  
  validate              :ensure_refusal_includes_reason
  
  validates             :additional_notes,
                        length: { maximum: 500 }
  
  belongs_to :reviewer, class_name: :User, foreign_key: :reviewer_id, optional: true
  belongs_to :withdrawer, class_name: :User, foreign_key: :withdrawer_id, optional: true
  
  has_one_attached :photo_id
  has_one_attached :doctors_note
  
  has_many :comments, as: :commentable
  
  # Tracks user agent info for incoming requests
  visitable :ahoy_visit
    
  # Non-sequential identifier scheme
  uniquify :identifier, length: 8, chars: ('A'..'Z').to_a + ('0'..'9').to_a

  scope :pending,         lambda { where(status: :pending) }  
  scope :voice_requested, lambda { where(status: :pending, voice_requested: true) }
  scope :ignored,         lambda { where(status: :ignored) }
  scope :denied,          lambda { where(status: :denied) }
  scope :withdrawn,       lambda { where(status: :withdrawn) }
  scope :eligible,        lambda { where(status: :eligible) }
  scope :watched,         lambda { where(watched: true) }  
  scope :search,          lambda { |search| where("lower(first_name) LIKE :search OR
                                                   lower(last_name) LIKE :search OR
                                                   lower(email) LIKE :search OR
                                                   lower(discord_username) LIKE :search OR
                                                   lower(player_id) LIKE :search OR
                                                   lower(identifier) LIKE :search",
                                                   search: "%#{search.downcase}%") }
  
  def to_param
    identifier
  end
  
  def full_name
    self.first_name + ' ' + self.last_name
  end
  
  def ignored?
    self.status.to_sym == :ignored
  end
  
  def pending?
    self.status.to_sym == :pending
  end
  
  def denied?
    self.status.to_sym == :denied
  end
  
  def withdrawn?
    self.status.to_sym == :withdrawn
  end
  
  def eligible?
    self.status.to_sym == :eligible
  end
  
  def issued?
    self.status.to_sym == :eligible || self.status.to_sym == :withdrawn
  end
  
  def reviewed?
    !self.reviewer_id.nil?
  end
  
  def last_reviewed_on
    if !self.withdrawer_id.nil?
      withdrawn_on
    elsif !self.reviewer_id.nil?
      reviewed_on
    end
  end
  
  # Search across the same fields for each of self's parameters aggregating results
  # Sort by most frequent matches across paramaters
  # Return ordered collection of uniques
  def related_requests
    reqs = (Verification.where.not(id: self.id).where("lower(email) LIKE '%#{self.email.downcase}%'") +
            Verification.where.not(id: self.id).where("lower(first_name) LIKE '%#{self.first_name.downcase.gsub(/'/,'')}%'") +
            Verification.where.not(id: self.id).where("lower(last_name) LIKE '%#{self.last_name.downcase.gsub(/'/,'')}%'") +
            Verification.where.not(id: self.id).where("lower(discord_username) LIKE '%#{self.discord_username.downcase}%'") +
            Verification.where.not(id: self.id).where("lower(player_id) LIKE '%#{self.player_id.downcase}%'"))
    
    reqs.uniq.sort_by { |e| -reqs.count(e)}
  end
  
  # Relaxed comparison that ignores case and leading/trailing whitespace
  def matching?(a, b)
    if a.blank? || b.blank?
      return false
    else
      a.downcase.strip == b.downcase.strip
    end
  end

  # Compares player data given to information on file for a given eligibility certificate
  # Returns hash of match/miss booleans showing matching parameters
  def validate(player_data)
    cross_check = {}
    cross_check[:full_name_validation] = matching?(self.full_name, player_data[:full_name]) ? 'match' : 'miss'
    cross_check[:email_validation]     = matching?(self.email, player_data[:email]) ? 'match' : 'miss'
    cross_check[:player_id_validation] = (matching?(self.player_id, player_data[:player_id]) && self.player_id_type == player_data[:player_id_type]) ? 'match' : 'miss'
    return cross_check
  end
  
  # Returns hash of player data submitted for certificate
  def validated_details
    {full_name:       self.full_name,
    email:            self.email,
    player_id:        self.player_id,
    player_id_type:   self.player_id_type,
    gender:           self.gender,
    pronouns:         self.pronouns}
  end

  protected
    def ensure_refusal_includes_reason
      if !self.status.blank?
        if ((self.denied? || self.withdrawn?) && self.refusal_reason.blank? )
          errors.add(:refusal_reason, "is required")
        end
      end
    end

    # Invoke some URI parsing magic to validate social links
    def ensure_valid_social_url
      if self.social_profile.present? && !valid_url?(social_profile)
        errors.add(:social_profile, "must be valid URL")
      end
    end
    
    def valid_url?(url)
      uri = URI.parse(url)
      uri.is_a?(URI::HTTP) && !uri.host.nil?
    rescue URI::InvalidURIError
      false
    end
    
  private
    # Set requested on time as record is created
    def ensure_requested_on_set
      if !self.requested_on.present?
        self.requested_on = Time.now
      end
    end
    
    # Set status as record is created
    def ensure_status_set
      if !self.status.present?
        self.status = :pending
      end
    end
    
    # Flag if attachments are submitted as record is created
    def flag_attachment_submission
      if self.photo_id.attached?
        self.photo_id_submitted = true
      end
      if self.doctors_note.attached?
        self.doctors_note_submitted = true
      end   
    end
    
end
