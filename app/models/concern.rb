class Concern < ApplicationRecord
  
  PLAYER_ID_TYPES = {
    riot:    "Riot ID",
    discord: "Discord Username",
    twitter: "Twitter Handle",
    name:    "Real Name"
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
    flagged:   "Flagged",
    all:       "All"
  }.freeze
  
  before_create :ensure_shared_on_set
  before_create :ensure_status_set
    
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
  
  scope :open,         lambda { where(status: :open) }
  scope :dismissed,    lambda { where(status: :dismissed) }
  scope :reviewed,     lambda { where(status: :reviewed) }
  scope :flagged,      lambda { where(flagged: true) }
  scope :search,       lambda { |search| where("lower(concerning_player_id) LIKE :search OR
                                                lower(concerned_email) LIKE :search OR
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
end
