class ResetAllPledgeCacheCounters < ActiveRecord::Migration[6.0]
  def up
    Pledge.all.each do |pledge|
      Pledge.reset_counters(pledge.id, :reports)
    end
  end
  
  def down
     # no rollback needed
  end

end
