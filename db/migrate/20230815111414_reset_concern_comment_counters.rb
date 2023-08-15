class ResetConcernCommentCounters < ActiveRecord::Migration[6.1]
  def up
    Concern.all.each do |concern|
      Concern.reset_counters(concern.id, :comments)
    end
  end

  def down
  end
end
