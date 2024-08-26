# This tasks counts the number of players that applied for verification using a BattleTag who were never certified.
# Uses emails as proxy for unique applicants.
# Hardcoded to work only for BattleTags.
# Should be updated to allow date ranges and different player ID types.

namespace :verifications do

  desc "Counts denied but never certified players who applied with BattleTags"

  task :count_denials, [:filename] => :environment do |task, args|
   
    emails = Verification.where(player_id_type: "blizzard").map{ |v| v.email.downcase }
    
    denied_never_certified = []
   
    emails.each do |e|
      requests = Verification.where(email: e, player_id_type: "blizzard")
      
      was_denied = false
      was_certified = false

      requests.each do |r|
        if r.status == "denied"
          was_denied = true
        elsif r.status == "eligible"
          was_certified = true
        end  
      end
      
      if was_denied && !was_certified
        denied_never_certified << e
      end
    end
    
    puts "#{denied_never_certified.count} requests were denied but never certified"
    
  end
end
