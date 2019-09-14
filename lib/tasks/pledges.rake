# This task imports past pledges from a CSV file
# usage: rake pledges:import_from_csv['~/temp.csv']

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
    Pledge.create({
      first_name: pledge["first_name"],
      last_name: pledge["last_name"],
      email: pledge["email"],
      signed_on: pledge["entry_date"],
      twitch_id: pledge["twitch_id"],
      twitch_display_name: pledge["twitch_display_name"],
      twitch_email: pledge["twitch_email"],
      twitch_authed_on: pledge["twitch_authed_on"]})
  end
  
end