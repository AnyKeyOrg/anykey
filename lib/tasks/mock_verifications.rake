# This task adds mock player request data
# to show the functionality and set a tone
# for the eligibility verification system
# usage: rake db:add_mock_verifications

namespace :db do
  
  desc "Add mock player data to verifications"

  task :add_mock_verifications => :environment do
  
    puts "Adding mock player data to verifications..."
    
    # Example to enter in walkthru and then approve
    # v = Verification.create(
    #     first_name: "Shy",
    #     last_name: "Guy",
    #     email: "deadshy@outlook.com",
    #     discord_username: "UltraShy#1003",
    #     player_id_type: "riot",
    #     player_id: "GigaBobomb#TSM",
    #     gender: "agender",
    #     pronouns: "he/they",
    #     social_profile: "https://twitter.com/GigaShy",
    #     voice_requested: false,
    #     photo_id_submitted: true,
    #     doctors_note_submitted: false,
    #     additional_notes: "",
    #     status: "pending")
    
    # Example to deny in walkthru
    # denial_reason: "Note from botanist contained no gender-related affirmation, only confirmation of ongoing treatment for biting aggression."
    v = Verification.create(
        first_name: "Piranha",
        last_name: "Plant",
        email: "piraplant@outlook.com",
        discord_username: "PiraPlant#5683",
        player_id_type: "riot",
        player_id: "PlantBoss#EZPZ",
        gender: "xenogender",
        pronouns: "xe/xem",
        social_profile: "https://twitter.com/PiraPlant",
        voice_requested: true,
        photo_id_submitted: false,
        doctors_note_submitted: true,
        additional_notes: "",
        status: "pending")
  
    # Example to ignore in walkthru
    v = Verification.create(    
        first_name: "Waluigi",
        last_name: "Bro",
        email: "wawawawa@gtfo.com",
        discord_username: "WickedStache#3527",
        player_id_type: "riot",
        player_id: "WickedStache#RIP",
        gender: "wutlol",
        pronouns: "what/why",
        social_profile: "",
        voice_requested: false,
        photo_id_submitted: true,
        doctors_note_submitted: false,
        additional_notes: "",
        status: "pending")      
        
    # Example to approve via voice in walkthru
    v = Verification.create(
        first_name: "Joanna",
        last_name: "Dark",
        email: "jodark@gmail.com",
        discord_username: "PerfectDark#1359",
        player_id_type: "riot",
        player_id: "SekritAgent#Vania",
        gender: "female",
        pronouns: "she/her",
        social_profile: "",
        voice_requested: true,
        photo_id_submitted: false,
        doctors_note_submitted: false,
        additional_notes: "",
        status: "pending")
    
    v = Verification.create(
        first_name: "Princess",
        last_name: "Peach",
        email: "peachyp@gmail.com",
        discord_username: "PeachyP#9301",
        player_id_type: "riot",
        player_id: "PeachyP#1337",
        gender: "woman",
        pronouns: "she/her",
        social_profile: "https://twitter.com/PeachyP",
        voice_requested: false,
        photo_id_submitted: true,
        doctors_note_submitted: false,
        additional_notes: "Also https://www.tiktok.com/@princess.peach_official",
        status: "pending")

    v = Verification.create(
        first_name: "Birdetta",
        last_name: "Birdo",
        email: "airliftbirdie@gmail.com",
        discord_username: "BirdettaXO#0267",
        player_id_type: "riot",
        player_id: "Birdetta#LOLO",
        gender: "transfemme",
        pronouns: "she/her",
        social_profile: "https://twitter.com/BirdettaXo",
        voice_requested: true,
        photo_id_submitted: true,
        doctors_note_submitted: true,
        additional_notes: "",
        status: "eligible",
        requested_on: Time.now-6.days,
        reviewed_on: Time.now-1.days,
        reviewer_id: User.first.id)

    v = Verification.create(
        first_name: "Link",
        last_name: "Link",
        email: "justlink@yahoo.com",
        discord_username: "justlink#0816",
        player_id_type: "riot",
        player_id: "Link#HyRulEz",
        gender: "femboy",
        pronouns: "he/they",
        social_profile: "https://twitter.com/codeliink",
        voice_requested: false,
        photo_id_submitted: true,
        doctors_note_submitted: false,
        additional_notes: "have onlyfans too",
        status: "eligible",
        requested_on: Time.now-4.days,
        reviewed_on: Time.now-1.days,
        reviewer_id: User.first.id)

    v = Verification.create(
        first_name: "Samus",
        last_name: "Aran",
        email: "sam@hotmail.com",
        discord_username: "metroidhunter#5522",
        player_id_type: "riot",
        player_id: "Varia#Vania",
        gender: "woman",
        pronouns: "she/her",
        social_profile: "",
        voice_requested: false,
        photo_id_submitted: true,
        doctors_note_submitted: false,
        additional_notes: "",
        status: "eligible",
        requested_on: Time.now-7.days,
        reviewed_on: Time.now-5.days,
        reviewer_id: User.first.id)

    v = Verification.create(
        first_name: "Razor",
        last_name: "Scummette",
        email: "razor@thescummettes.com",
        discord_username: "RazorScum#6666",
        player_id_type: "riot",
        player_id: "RazorScum#Maniacs",
        gender: "grrl",
        pronouns: "she/her",
        social_profile: "https://tiktok.com/@RazorScum",
        voice_requested: false,
        photo_id_submitted: true,
        doctors_note_submitted: false,
        additional_notes: "",
        status: "eligible",
        requested_on: Time.now-2.days,
        reviewed_on: Time.now-1.days,
        reviewer_id: User.first.id)

    v = Verification.create(
        first_name: "Kirby",
        last_name: "Star",
        email: "kirby.star@smith.edu",
        discord_username: "pinkbeast#0001",
        player_id_type: "riot",
        player_id: "PinkBeast#Smash",
        gender: "non-binary",
        pronouns: "he/they",
        social_profile: "",
        voice_requested: true,
        photo_id_submitted: "",
        doctors_note_submitted: "",
        additional_notes: "",
        status: "pending")

    v = Verification.create(
        first_name: "Lucca",
        last_name: "Ashtear",
        email: "ashtear@gmail.com",
        discord_username: "ashestoashes#4411",
        player_id_type: "riot",
        player_id: "AshTear#Cozy",
        gender: "demigirl",
        pronouns: "she/they",
        social_profile: "",
        voice_requested: false,
        photo_id_submitted: true,
        doctors_note_submitted: false,
        additional_notes: "",
        status: "denied",
        denial_reason: "School ID provided does not have a sex/gender marker",
        requested_on: Time.now-5.days,
        reviewed_on: Time.now-4.days,
        reviewer_id: User.first.id)

    v = Verification.create(
        first_name: "Yoshi",
        last_name: "Egg",
        email: "hello@yoshi.me",
        discord_username: "Yoshi#8603",
        player_id_type: "riot",
        player_id: "Yoshi#Eaters",
        gender: "transmasc enby",
        pronouns: "he/they",
        social_profile: "https://tiktok.com/@Yoshi",
        voice_requested: false,
        photo_id_submitted: false,
        doctors_note_submitted: false,
        additional_notes: "i like eggs",
        status: "pending")

    v = Verification.create(
        first_name: "Jiggly",
        last_name: "Puff",
        email: "jigglypuff@yahoo.com",
        discord_username: "puffpuff#5934",
        player_id_type: "riot",
        player_id: "PuffPuff#Poof",
        gender: "non-binary",
        pronouns: "they/she",
        social_profile: "https://twitter.com/puffpuff",
        voice_requested: false,
        photo_id_submitted: false,
        doctors_note_submitted: true,
        additional_notes: "",
        status: "eligible",
        requested_on: Time.now-8.days,
        reviewed_on: Time.now-7.days,
        reviewer_id: User.first.id)

    v = Verification.create(
        first_name: "Wii Fit",
        last_name: "Trainer",
        email: "wiifit@dailygains.org",
        discord_username: "DailyGains#9425",
        player_id_type: "riot",
        player_id: "WiiFit#Shirobi",
        gender: "woman",
        pronouns: "she/any",
        social_profile: "",
        voice_requested: false,
        photo_id_submitted: true,
        doctors_note_submitted: false,
        additional_notes: "",
        status: "eligible",
        requested_on: Time.now-5.days,
        reviewed_on: Time.now-3.days,
        reviewer_id: User.first.id)

    v = Verification.create(
        first_name: "Rosalina",
        last_name: "Luma",
        email: "lumarowrites@gmail.com",
        discord_username: "Lumaro_#7474",
        player_id_type: "riot",
        player_id: "Lumaro#Celeste",
        gender: "trans woman",
        pronouns: "she/her",
        social_profile: "https://www.tumblr.com/lumarowrites/tagged/gender%20updates",
        voice_requested: true,
        photo_id_submitted: false,
        doctors_note_submitted: false,
        additional_notes: "",
        status: "eligible",
        requested_on: Time.now-6.days,
        reviewed_on: Time.now-2.days,
        reviewer_id: User.first.id)

    v = Verification.create(
        first_name: "Iggy",
        last_name: "Koopa",
        email: "ikoop@yahoo.com",
        discord_username: "KaosBruh#5242",
        player_id_type: "riot",
        player_id: "Iggles#LOLO",
        gender: "NB",
        pronouns: "they/them",
        social_profile: "https://twitter.com/Iggy_bestkoopa",
        voice_requested: false,
        photo_id_submitted: true,
        doctors_note_submitted: false,
        additional_notes: "",
        status: "ignored",
        requested_on: Time.now-2.days,
        reviewed_on: Time.now-1.days,
        reviewer_id: User.first.id)

    puts "Operation complete."
  
  end
end