# coding: utf-8
class Partner < ActiveRecord::Base
	include FieldsTranslation

	include Image # 220x66 
  mount_uploader :image, PartnerUploader

	scope :sort, -> (sn = "") { or_default(sn) }
  scope :or_default, -> (sn = "") { order("position desc") if sn == "" || sn.nil? }

	def title(lan = nil)
    get_field('title', lan)
	end
end
