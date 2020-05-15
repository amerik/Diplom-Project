# coding: utf-8
class Country < ActiveRecord::Base
	has_many :cities
	has_many :profiles, :dependent => :destroy
	
	scope :sort, -> (sn = "") { or_default_ru(sn).or_default(sn).or_name_rus_d(sn).or_name_rus_a(sn).or_name_en_d(sn).or_name_en_a(sn) }
	scope :or_default_ru, -> (sn = "") { order("name_rus asc") if Translation.current_lan == 'ru' && (sn == "" || sn.nil?) }
	scope :or_default, -> (sn = "") { order("name_en asc") if Translation.current_lan != 'ru' && (sn == "" || sn.nil?) }
	scope :or_name_rus_a, -> (sn = "") { order("name_rus asc") if sn == "order_name_rus_asc" }
  scope :or_name_rus_d, -> (sn = "") { order("name_rus desc") if sn == "order_name_rus_desc" }
  scope :or_name_en_a, -> (sn = "") { order("name_en asc") if sn == "order_name_en_asc" }
  scope :or_name_en_d, -> (sn = "") { order("name_en desc") if sn == "order_name_en_desc" }
	scope :has_search, -> (text) { where("lower(name_rus) like lower(?) or lower(name_en) like lower(?)", "%#{text}%", "%#{text}%") }

	def get_name
		if Translation.current_lan == 'ru'
			self.name_rus
		else
			self.name_en
		end
	end
end
