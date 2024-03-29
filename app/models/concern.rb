class Concern < ApplicationRecord
  
  PLAYER_ID_TYPES = {
    blizzard: "Blizzard BattleTag",
    discord:  "Discord Username",
    ea:       "EA (Electronic Arts) ID",
    epic:     "Epic Games Display Name",
    nickname: "Nickname",
    name:     "Real Name",
    riot:     "Riot ID",
    steam:    "Steam Profile Name",
    twitter:  "Twitter Handle"
  }.freeze
  
  STATUSES = {
    open:      "Open",
    dismissed: "Dismissed",
    reviewed:  "Reviewed"
  }.freeze
  
  SORT_FILTERS = {
    open:      "Open",
    dismissed: "Dismissed",
    reviewed:  "Reviewed",
    watched:   "Watched",
    all:       "All"
  }.freeze
  
  before_create :ensure_shared_on_set
  before_create :ensure_status_set
  before_create :count_screenshots_submitted
    
  validates_presence_of :concerning_player_id,
                        :concerning_player_id_type,
                        :description,
                        :concerned_email
                        
  validates_format_of   :concerned_email,
                        with: /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]+\z/,
                        if: lambda { |x| x.concerned_email.present? }

  validates             :background,
                        length: { maximum: 500 }

  validates             :description,
                        length: { maximum: 1000 }
                       
  validates             :recommended_response,
                        length: { maximum: 500 }

  validates             :concerned_cert_code,
                        length: { is: 8 },
                        if: lambda { |x| x.concerned_cert_code.present? }

  belongs_to :reviewer, class_name: :User, foreign_key: :reviewer_id, optional: true

  has_many_attached :screenshots
  
  has_many :comments, as: :commentable
  
  # Tracks user agent info for incoming concerns
  visitable :ahoy_visit
  
  scope :open,         lambda { where(status: :open) }
  scope :dismissed,    lambda { where(status: :dismissed) }
  scope :reviewed,     lambda { where(status: :reviewed) }
  scope :watched,      lambda { where(watched: true) }
  scope :search,       lambda { |search| where("lower(concerning_player_id) LIKE :search OR
                                                lower(concerned_email) LIKE :search OR
                                                lower(concerned_cert_code) LIKE :search OR
                                                lower(description) LIKE :search OR
                                                lower(background) LIKE :search",
                                                search: "%#{search.downcase}%") }

  def open?
    self.status.to_sym == :open
  end

  def dismissed?
    self.status.to_sym == :dismissed
  end

  def reviewed?
    self.status.to_sym == :reviewed
  end

  def word_count
    return (self.description + " " + self.background + " " + self.recommended_response).gsub(/[^\w\s]/,"").split.count
  end

  def concerned_salutation_name
    if !self.concerned_cert_code.blank?
      if player = Verification.find_by(identifier: self.concerned_cert_code)
        return player.first_name
      end
    end
    return self.concerned_email.gsub(/\@.*/,"")
  end

  private
    # Set requested on time as concern is created
    def ensure_shared_on_set
      if !self.shared_on.present?
        self.shared_on = Time.now
      end
    end

    # Set status as concern is created
    def ensure_status_set
      if !self.status.present?
        self.status = :open
      end
    end
    
    # Store count of attachments submitted as concern is created
    def count_screenshots_submitted
      if self.screenshots.attached?
        self.screenshots_submitted_count = self.screenshots.size
      else
        self.screenshots_submitted_count = 0
      end
    end
end
