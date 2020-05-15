# coding: utf-8
class University < ActiveRecord::Base
	has_many :profiles, :dependent => :destroy
	
	scope :sort, -> (sn = "") { or_default(sn) }
  scope :or_default, -> (sn = "") { order("id asc") if sn.nil? || sn == "" }
end
