# coding: utf-8
class City < ActiveRecord::Base
	belongs_to :country
	has_many :profiles, :dependent => :destroy

	scope :search_name, -> (value) { where('lower(name_rus) like lower(?)', "%#{value}%") }
	scope :by_russia, -> { joins(:country).where("countries.name_rus = 'Россия'").order("cities.name_rus asc") }
	scope :sort, -> (sn = "") { or_default_ru(sn).or_default(sn).or_name_rus_d(sn).or_name_rus_a(sn).or_name_en_d(sn).or_name_en_a(sn) }
	scope :or_default_ru, -> (sn) { order("name_rus asc") if Translation.current_lan == 'ru' && (sn == "" || sn.nil?) }
	scope :or_default, -> (sn) { order("name_en asc") if Translation.current_lan != 'ru' && (sn == "" || sn.nil?) }
	scope :or_name_rus_a, -> (sn) { order("name_rus asc") if sn == "order_name_rus_asc" }
  scope :or_name_rus_d, -> (sn) { order("name_rus desc") if sn == "order_name_rus_desc" }
  scope :or_name_en_a, -> (sn) { order("name_en asc") if sn == "order_name_en_asc" }
  scope :or_name_en_d, -> (sn) { order("name_en desc") if sn == "order_name_en_desc" }
  scope :has_search, -> (text) { where("lower(name_rus) like lower(?) or lower(name_en) like lower(?)", "%#{text}%", "%#{text}%") }
  scope :has_country, -> (country_id) { where("country_id = ?", country_id) if country_id.to_i > 0 }
end
