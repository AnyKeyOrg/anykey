class ResetConcernScreenshotSubmittedCounts < ActiveRecord::Migration[6.1]
  def up
    Concern.all.each do |concern|
      if concern.screenshots.attached?
        concern.screenshots_submitted_count = concern.screenshots.size
      else
        concern.screenshots_submitted_count = 0
      end
      concern.save
    end
  end

  def down
  end
end
