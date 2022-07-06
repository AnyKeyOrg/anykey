class Comment < ApplicationRecord
  validates_presence_of   :report_id,
                          :commenter_id,
                          :body

  belongs_to  :commenter, class_name: :User, foreign_key: :commenter_id
  belongs_to  :report
  belongs_to  :parent_comment, class_name: :Comment, foreign_key: :parent_comment_id, optional: true
  has_many    :replies, class_name: :Comment, foreign_key: :parent_comment_id

end
