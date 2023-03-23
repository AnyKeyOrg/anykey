class Verification < ApplicationRecord
  
  require 'csv'
  require 'uri'
  
  STATUSES = {
    pending:  "Pending",
    ignored:  "Ignored",
    denied:   "Denied",
    eligible: "Eligible"
  }.freeze
  
  SORT_FILTERS = {
    pending:          "Pending",
    voice_requested:  "Voice",
    ignored:          "Ignored",
    denied:           "Denied",
    eligible:         "Eligible",
    all:              "All"
  }.freeze
  
  PLAYER_ID_TYPES = {
    riot: "Riot ID"
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
                        
  validates_format_of   :discord_username,
                        with: /\A.+#[0-9]{4}\z/,
                        if: lambda { |x| x.discord_username.present? }
  
  validate              :ensure_valid_social_url
  
  validate              :ensure_denial_includes_reason
  
  validates             :additional_notes,
                        length: { maximum: 500 }
                        
  belongs_to :reviewer, class_name: :User, foreign_key: :reviewer_id, optional: true                      
                          
  has_one_attached :photo_id
  has_one_attached :doctors_note
    
  # Non-sequential identifier scheme   
  uniquify :identifier, length: 8, chars: ('A'..'Z').to_a + ('0'..'9').to_a

  scope :pending,         lambda { where(status: :pending) }  
  scope :voice_requested, lambda { where(status: :pending, voice_requested: true) }
  scope :ignored,         lambda { where(status: :ignored) }
  scope :denied,          lambda { where(status: :denied) }
  scope :eligible,        lambda { where(status: :eligible) }
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
  
  def eligible?
    self.status.to_sym == :eligible
  end
  
  def reviewed?
    !self.reviewer_id.nil?
  end
  
  def related_requests
    # Search for each of self's parameters aggregating results
    # Sort by most frequent matches across paramaters
    # Return ordered collection of uniques
    reqs = (Verification.where.not(id: self.id).search(self.email) +
            Verification.where.not(id: self.id).search(self.first_name) +
            Verification.where.not(id: self.id).search(self.last_name) +
            Verification.where.not(id: self.id).search(self.discord_username) +
            Verification.where.not(id: self.id).search(self.player_id))

    reqs.uniq.sort_by { |e| -reqs.count(e)}
  end


  def validated_details
    # Returns hash of player data submitted for certificate
    # TODO: Generalize this method for future player_id_types
    {full_name:       self.full_name,
    email:            self.email,
    discord_username: self.discord_username,
    player_id:        self.player_id,
    gender:           self.gender,
    pronouns:         self.pronouns}
  end

  def validate(player_data)
    # Compares player data given to information on file for a given eligibility certificate
    # Returns hash of booleans showing matching parameters
    # TODO: DRY and generalize this method for future player_id_types
    cross_check = {}
    cross_check[:full_name_validation]        = self.full_name == player_data[:full_name] ? 'match' : 'miss'
    cross_check[:email_validation]            = self.email == player_data[:email] ? 'match' : 'miss'
    cross_check[:discord_username_validation] = self.discord_username == player_data[:discord_username] ? 'match' : 'miss'
    cross_check[:player_id_validation]        = self.player_id == player_data[:player_id] ? 'match' : 'miss'
    return cross_check
  end

  protected
    def ensure_denial_includes_reason
      if !self.status.blank?
        if (self.denied? && self.denial_reason.blank? )
          errors.add(:denial_reason, "is required")
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
