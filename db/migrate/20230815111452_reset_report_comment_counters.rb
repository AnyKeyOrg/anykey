class ResetReportCommentCounters < ActiveRecord::Migration[6.1]
  def up
    Report.all.each do |report|
      Report.reset_counters(report.id, :comments)
    end
  end

  def down
  end
end
