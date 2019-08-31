# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Set up the admin user
user = User.where(first_name: "Bjorn", last_name: "Disway", username: "bjornadmin", email: "bjorn@anykey.org").first_or_create(password: "changeme")
user.update_attribute(:is_admin, true)
