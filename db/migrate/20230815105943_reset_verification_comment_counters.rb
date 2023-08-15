class ResetVerificationCommentCounters < ActiveRecord::Migration[6.1]
  def up
    Verification.all.each do |verification|
      Verification.reset_counters(verification.id, :comments)
    end
  end

  def down
  end
end
