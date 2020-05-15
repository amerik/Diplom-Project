# coding: utf-8
class PageHelp < ActiveRecord::Base
	include FieldsTranslation	
	belongs_to :category

	scope :sort, -> (sn = "") { or_default(sn) }
  scope :or_default, -> (sn = "") { order("id asc") if sn == "" || sn.nil? }
	scope :has_kind, -> (kind) { joins("inner join categories on categories.id = page_helps.category_id").where("categories.kind = ?", "#{kind}").uniq }
	scope :by_search, -> (text) { joins("inner join translations on translations.attach_id = page_helps.id").where("lower(translations.value) like lower(?)", "%#{text}%").uniq }
	scope :has_category, -> (category_id) { where("category_id = ?", category_id) }

	def name(lan = nil)
    get_field('name', lan)
	end

	def description(lan = nil)
    get_field('description', lan)
	end
end
