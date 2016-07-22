# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
AiPlayer.where(username: "Donald Trump", bet_style: "aggressive", cash: rand(1000..2000)).first_or_create
AiPlayer.where(username: "Hillary Clinton", bet_style: "conservative", cash: rand(1000..2000)).first_or_create
AiPlayer.where(username: "Bernie Sanders", bet_style: "aggressive", cash: rand(1000..2000)).first_or_create
AiPlayer.where(username: "Ted Cruz", bet_style: "conservative", cash: rand(1000..2000)).first_or_create
AiPlayer.where(username: "Rosco", bet_style: "aggressive", cash: rand(1000..2000)).first_or_create
AiPlayer.where(username: "Oscar", bet_style: "conservative", cash: rand(1000..2000)).first_or_create
AiPlayer.where(username: "Martha", bet_style: "conservative", cash: rand(1000..2000)).first_or_create
AiPlayer.where(username: "Colbert", bet_style: "conservative", cash: rand(1000..2000)).first_or_create
AiPlayer.where(username: "Engrid", bet_style: "aggressive", cash: rand(1000..2000)).first_or_create
puts "created ai players"
