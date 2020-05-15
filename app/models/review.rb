# coding: utf-8
class Review < ActiveRecord::Base
	belongs_to :user

	include FieldsTranslation

	include Image # 42x42 165x165
  mount_uploader :image, ReviewUploader

	scope :sort, -> (sn = "") { or_default(sn) }
  scope :or_default, -> (sn = "") { order("id desc") if sn == "" || sn.nil? }

	def name(lan = nil)
    get_field('name', lan)
	end	

	def location(lan = nil)
    get_field('location', lan)
	end	

	def description(lan = nil)
    get_field('description', lan)
	end			
end
