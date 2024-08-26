# This tasks counts the number of players that applied for verification using a BattleTag who were never certified.
# Uses emails as proxy for unique applicants.
# Hardcoded to work only for Blizzard BattleTags.
# Should be updated to allow date ranges and different player ID types.

namespace :verifications do

  desc "Counts denied but never certified players who applied with BattleTags"

  task :count_denials, [:filename] => :environment do |task, args|
   
    emails = Verification.where(player_id_type: "blizzard").map{ |v| v.email.downcase }.uniq
    
    puts "#{emails.count} unique email addresses applied with Blizzard BattleTags"
    
    denied_never_certified = []

    denied_then_certified = []
   
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
      
      if was_denied && was_certified
        denied_then_certified << e
      end
    end
    
    puts denied_never_certified
    
    puts "#{denied_never_certified.count} email addresses were denied but never certified"
    
    
    puts denied_then_certified
    
    puts "#{denied_then_certified.count} email addresses were denied and then later certified"
    
  end
end
