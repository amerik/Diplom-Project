# coding: utf-8
class UserAchivment < ActiveRecord::Base
	belongs_to :user
	belongs_to :achivment
	belongs_to :task

	scope :sort, -> (sn = "") { or_default(sn) }
  scope :or_default, -> (sn = "") { order("id desc") if sn == "" || sn.nil? }
end
