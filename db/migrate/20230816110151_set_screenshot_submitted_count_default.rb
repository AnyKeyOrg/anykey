class SetScreenshotSubmittedCountDefault < ActiveRecord::Migration[6.1]
  def change
    change_column_default :concerns, :screenshots_submitted_count, 0
  end
end
