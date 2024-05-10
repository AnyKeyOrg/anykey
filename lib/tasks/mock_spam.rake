namespace :db do
    desc "Load custom seed data"
    task :load_custom_data => :environment do
      load Rails.root.join('db', 'test_data.rb')
    end
  end
  