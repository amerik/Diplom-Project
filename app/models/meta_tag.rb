# coding: utf-8
class MetaTag < ActiveRecord::Base
	include FieldsTranslation

	belongs_to :attach, :polymorphic => true

	scope :sort, -> (sn = "") { or_default(sn) }
  scope :or_default, -> (sn = "") { order("id desc") if sn == "" || sn.nil? }

	def title(lan = nil)
    get_field('title', lan)
	end

	def keywords(lan = nil)
    get_field('keywords', lan)
	end

	def description(lan = nil)
    get_field('description', lan)
	end
end
