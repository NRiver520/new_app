# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
10.times do |i|
  User.create!(username: Faker::Internet.username,
               email: Faker::Internet.unique.email,
               password: "password",
               password_confirmation: "password",
               comments_count: case i
                               when 0
                                0
                               when 1
                                20
                               when 2
                                150
                               when 3
                                300
                               when 4
                                501
                               else 
                                Faker::Number.between(from: 0, to: 550)
                               end
  )
end

user_ids = User.ids

20.times do |index|
  user = User.find(user_ids.sample)
  user.boards.create!(title: "タイトル#{index}",body: "本文#{index}")
end