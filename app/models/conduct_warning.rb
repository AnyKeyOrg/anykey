class ConductWarning < ApplicationRecord
  validates_presence_of :pledge_id, :report_id, :reviewer_id, :reason

  belongs_to :pledge
  belongs_to :report
  belongs_to :reviewer, class_name: :User, foreign_key: :reviewer_id
  
end
