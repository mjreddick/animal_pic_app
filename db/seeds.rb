# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

pics = Picture.all
pics.each do |pic|
	pic.remove_image!
end
User.delete_all
Picture.delete_all

usernames = ['matt', 'matthew', 'jimmy', 'james', 'marina', 'joey', 'richard',
	'fred', 'freddy', 'tim', 'jim', 'bill', 'stan', 'stanley', 'micah', 'mike',
	'michael', 'jeff', 'jeffery', 'mark', 'marcus', 'monica', 'ross', 'rachel'];

usernames.each do |u|
	user = User.create({username: u, email: "#{u}@example.com", password: "#{u}pass",
		password_confirmation: "#{u}pass", pet_name: "#{u}'s pet"})
	user.save
	pic = user.pictures.new({title: "test"})
	pic.image.store!(File.open("/Users/matthew/Desktop/Various Animal Pictures/smallish_cat.jpg"))
	pic.save
end

# users = User.create([
# 	{username: "Jimbo1", pet_name: "Jim", email: "jimbo@jimbo.com", password: "pass1"},
# 	{username: "BRich", pet_name: "Micah", email: "micah@micah.com", password: "pass2"}
# 	])
