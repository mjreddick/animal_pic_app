# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
User.delete_all
users = User.create([
	{username: "Jimbo1", pet_name: "Jim", email: "jimbo@jimbo.com", password: "pass1"},
	{username: "BRich", pet_name: "Micah", email: "micah@micah.com", password: "pass2"}
	])
