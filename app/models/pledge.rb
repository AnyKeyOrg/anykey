class Pledge < ApplicationRecord
  
  SORT_FILTERS = {
    unactivated: "Unactivated",
    activated:   "Activated",
    revoked:     "Revoked",
    all:         "All"
  }.freeze
  
  before_create :ensure_signed_on_set
  
  after_create :increment_counter
  
  after_destroy :decrement_counter
  
  validates_presence_of    :first_name,
                           :last_name,
                           :email
  validates_uniqueness_of  :email,
                           case_sensitive: false
  validates_format_of      :email,
                           with: /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]+\z/,
                           if: lambda { |x| x.email.present? }
  
  belongs_to :referrer, class_name: :Pledge, foreign_key: :referrer_id, optional: true
  has_many :referrals, class_name: :Pledge, foreign_key: :referrer_id
  
  # Non-sequential identifier scheme   
  uniquify :identifier, length: 8, chars: ('A'..'Z').to_a + ('0'..'9').to_a
  
  scope :unactivated,  lambda { where(twitch_id: nil) }
  scope :activated,    lambda { where.not(twitch_id: nil).where(badge_revoked: false) }
  scope :revoked,      lambda { where(badge_revoked: true) }
  scope :search,       lambda { |search| where("lower(first_name) LIKE :search OR
                                                lower(last_name) LIKE :search OR
                                                lower(email) LIKE :search OR
                                                lower(twitch_display_name) LIKE :search OR
                                                lower(twitch_id) LIKE :search OR
                                                lower(twitch_email) LIKE :search",
                                                search: "%#{search.downcase}%") }
  
  def to_param
    identifier
  end
  
  def full_name
    self.first_name + ' ' + self.last_name
  end
  
  def leadboard_name
    if self.badge_revoked
      return '*******'
    elsif !self.twitch_display_name.blank?
      return self.twitch_display_name
    else
      return self.first_name + ' ' + self.last_name.first + '.'
    end
  end
  
  def reports_about
    unless self.twitch_id.blank?
      Report.where(reported_twitch_id: self.twitch_id)
    end
  end
  
  def reports_filed
    if self.twitch_id.blank?
      Report.where(reporter_email: self.email)
    else
      Report.where("reporter_email= ? OR reporter_twitch_id = ?", self.email, self.twitch_id)
    end
  end

  def self.cached_count
    Rails.cache.fetch(:pledge_count, expires_in: 1.day) do
      Pledge.count
    end
  end
  
  def self.cached_leaders
    Rails.cache.fetch(:pledge_leaders, expires_in: 1.day) do
      # Compute the pledgers with the most referral during the current calendar year
      leaders = Pledge.select("referrer_id, count(referrer_id) as counter").where('referrer_id IS NOT NULL AND signed_on >= ? AND signed_on < ?', Time.now.beginning_of_year, Time.now).group(:referrer_id).order(counter: :desc).limit(10)
      
      # Compose the leaderboard
      leaderboard = []
      leaders.each do |leader|
        leaderboard << { leadboard_name: Pledge.find(leader[:referrer_id]).leadboard_name, referrals_count: leader[:counter] }
      end
      
      leaderboard
    end
  end
  
  private
    def ensure_signed_on_set
      if !self.signed_on.present?
        self.signed_on = Time.now
      end
    end
    
    def increment_counter
      Rails.cache.increment('pledge_count')
    end
    
    def decrement_counter
      Rails.cache.decrement('pledge_count')
    end
    
end
