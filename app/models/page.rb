# coding: utf-8
class Page < ActiveRecord::Base
	include FieldsTranslation

	has_one :meta_tag, :dependent => :destroy, as: :attach

	scope :sort, -> (sn = "") { or_default(sn) }
  scope :or_default, -> (sn = "") { order("id asc") if sn == "" || sn.nil? }

  def h1(lan = nil)
    get_field('h1', lan)
	end

	def description(lan = nil)
    get_field('description', lan)
	end
end
