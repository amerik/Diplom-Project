# coding: utf-8
class Category < ActiveRecord::Base
	include FieldsTranslation	
	has_many :page_helps

	extend Enumerize
	enumerize :kind, in: %w(client mentor), predicates: true
	enumerize :alias, in: %w(popular customize study pricing faq), predicates: true

	scope :sort, -> (sn = "") { or_default(sn) }
  scope :or_default, -> (sn = "") { order("position desc") if sn == "" || sn.nil? }
	scope :has_kind, -> (kind) { where("kind = ?", kind) if !kind.nil? && kind != "" }
	
	

	def name(lan = nil)
    get_field('name', lan)
	end		
end
