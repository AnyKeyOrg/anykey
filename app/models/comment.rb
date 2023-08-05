class Comment < ApplicationRecord
  
  before_create :ensure_posted_on_set
  
  validates_presence_of :body
  
  belongs_to :commentable, polymorphic: true
  belongs_to :commenter, class_name: :User, foreign_key: :commenter_id
  
  private
    # Set posted on time as comment is created
    def ensure_posted_on_set
      if !self.posted_on.present?
        self.posted_on = Time.now
      end
    end
  
end
