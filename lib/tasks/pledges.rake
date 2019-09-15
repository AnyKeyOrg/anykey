# This task imports past pledges from a CSV file
# usage: rake pledges:import_from_csv['/path/to/pledges.csv']

# To use this task on Heroku...
# Encrypt the csv data using `gpg -c pledges.csv`
# Take note of the passphrase you used
# Place the pledges.csv.gpg file into the /storage folder
# Check the code into git and push to Heroku
# Access Heroku with `heroku run bash`
# Decrypt the file with `gpg --pinentry-mode loopback -d pledges.csv.gpg > pledges.csv`
# Delete the decrypted file after import

namespace :pledges do
  
  desc "Import past pledges from csv"

  task :import_from_csv, [:filename] => :environment do |task, args|
    
    require 'csv'    

    csv_text = File.read(args[:filename])
    csv      = CSV.parse(csv_text, headers: true)
    csv.each do |row|
      puts "Importing: #{row.to_hash["email"]}\n"
      import_pledge(row.to_hash)
    end
  end


  def import_pledge(pledge)
    np = Pledge.new({
      first_name: pledge["first_name"],
      last_name: pledge["last_name"],
      email: pledge["email"],
      signed_on: pledge["entry_date"],
      twitch_id: pledge["twitch_id"],
      twitch_display_name: pledge["twitch_display_name"],
      twitch_email: pledge["twitch_email"],
      twitch_authed_on: pledge["twitch_authed_on"]})
    np.save(validate: false)    
  end
  
end