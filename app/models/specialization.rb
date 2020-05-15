# coding: utf-8
class Specialization < ActiveRecord::Base
	belongs_to :profile

	scope :sort, -> (sn = "") { or_default(sn) }
  scope :or_default, -> (sn = "") { order("id asc") if sn.nil? || sn == "" }
end
