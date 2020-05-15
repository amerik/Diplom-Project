# coding: utf-8
class Achivment < ActiveRecord::Base
	include FieldsTranslation

	has_many :user_achivments, :dependent => :destroy
	has_many :tasks, :dependent => :destroy

	include Image # none
  mount_uploader :image, AchivmentUploader

	scope :sort, -> (sn = "") { or_default(sn) }
  scope :or_default, -> (sn = "") { order("id asc") if sn == "" || sn.nil? }

	def name(lan = nil)
    get_field('name', lan)
	end

	def description(lan = nil)
    get_field('description', lan)
	end
end
