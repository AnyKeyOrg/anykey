class Comment < ApplicationRecord
  
  before_create :ensure_posted_on_set
  
  validates_presence_of :body
  
  belongs_to :commentable, polymorphic: true, counter_cache: true
  belongs_to :commenter, class_name: :User, foreign_key: :commenter_id
  
  # Finds and renders links in text using regex
  # Thanks to solution on StackOverflow (16006016)
  def clickable_body
    self.body.gsub(%r{
        (?:(?:https?|ftp|file):\/\/|www\.|ftp\.)
        (?:\([-A-Z0-9+&@#\/%=~_|$?!:,.]*\)|[-A-Z0-9+&@#\/%=~_|$?!:,.])*
        (?:\([-A-Z0-9+&@#\/%=~_|$?!:,.]*\)|[A-Z0-9+&@#\/%=~_|$])
      }ix, '<a href="\0" class="inline">\0</a>')
  end
  
  private
    # Set posted on time as comment is created
    def ensure_posted_on_set
      if !self.posted_on.present?
        self.posted_on = Time.now
      end
    end
  
end
