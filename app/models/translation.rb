# coding: utf-8
class Translation < ActiveRecord::Base
	class_attribute :current_lan

	belongs_to :attach, :polymorphic => true

	extend Enumerize
	enumerize :lan, in: %w(en ru), predicates: true

	scope :by_field, -> (field, lan = Translation.current_lan) { where("field = ? and lan = ?", field, lan) }
	scope :by_search, -> (text) { where("lower(value) like lower(?) and (attach_type = 'Page' or attach_type = 'Press' or attach_type = 'Country' or attach_type = 'City' or attach_type = 'Region' or attach_type = 'Apartment' or attach_type = 'Concierge')", "%#{text}%") }
	scope :by_search_article, -> (text) { joins("inner join apartments on translations.attach_id = apartments.id and translations.attach_type = 'Apartment'").where("lower(article) like lower(?) and translations.field = 'name'", "%#{text}%").uniq }
end