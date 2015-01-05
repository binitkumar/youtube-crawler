# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


Countary.delete_all
country = CLIENT.execute!(
      :api_method => YOUTUBE.i18n_regions.list,
      :parameters => {
        :part => 'id, snippet'
      }
    )

country_data = JSON.parse(country.response.body)["items"]
country_data.each do |cnt|
  Countary.create(name: cnt["snippet"]["name"], code: cnt["id"])
end

puts "#{Countary.count} countries loaded."

categories = CLIENT.execute!(
      :api_method => YOUTUBE.guide_categories.list,
      :parameters => {
        :part => 'id, snippet',
        :regionCode => "US",
      }
    )

Categories.delete_all
categories_data = JSON.parse(categories.response.body)["items"]
categories_data.each do |category|
  Categories.create(
    name: category["snippet"]["title"],
    code: category["id"]
  )
end

puts "#{Categories.count} categories loaded"
