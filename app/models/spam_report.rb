class SpamReport < ApplicationRecord
  # foreign keys for the two reports
  belongs_to :report1, class_name: "Report", foreign_key: "report1_id"
  belongs_to :report2, class_name: "Report", foreign_key: "report2_id"

  # validations
  validates :description, presence: true
  validates :report1_id, presence: true
  validates :report2_id, presence: true
  validate :reports_must_be_different

  private
  def reports_must_be_different
    errors.add(:report2_id, "must be different from report1") if report1_id == report2_id
  end
  
end