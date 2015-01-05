# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

workbook = Spreadsheet.open("db/country_codes.xls")
sheet1 = workbook.worksheet 0

Countary.delete_all
sheet1.each do |row|
  Countary.create(name: row[0], code: row[2])
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
