# coding: utf-8

# bundle exec rake tables:add_countries

namespace :tables do
  desc "Add Countries"
  task :add_countries => :environment do
    # чистка данных

  	#0 - стереть все страны и города Country.delete_all
    Country.delete_all
    City.delete_all

  	p "============1 - загрзка стран и названия картинок в переменную flag"
  	query = File.read("./public/countries/countries.sql")
		ActiveRecord::Base.connection.execute(query)
		co = Country.find(84)
		co.update_attribute(:name_rus, "Кот-д'Ивуар")
    co = Country.find(84)
    co.update_attribute(:name_en, "Côte d'Ivoire")

    # p "============Флаги для стран"
    # Country.all.each do |country|
    #   country.image = File.open("./public/countries/flags/#{country.flag}")
    #   country.save
    # end

  	p "============2 - загрузка городов"
  	query = File.read("./public/countries/cities.sql")
		ActiveRecord::Base.connection.execute(query)
		dd = City.find(5021)
		dd.update_attribute(:name_en, "Modi'in-Maccabim-Re'ut")

  	p "============3 - Country.each" 
  	Country.all.each do |value|
      value.name_rus = value.name_rus.strip
      value.name_en = value.name_en.strip
  		value.save
  	end

    p "============4 - City.each" 
    City.all.each_with_index do |value, index|
      value.name_rus = value.name_rus.strip
      value.name_en = value.name_en.strip

      if value.name_en.include?('1') || value.name_en.include?('2') || value.name_en.include?('3') || value.name_en.include?('4') || value.name_en.include?('5') || value.name_en.include?('6') || value.name_en.include?('7') || value.name_en.include?('8') || value.name_en.include?('9') || value.name_en.include?('0')
        value.delete
      else
        value.save
      end
    end
  end
end