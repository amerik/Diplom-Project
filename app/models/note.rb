# coding: utf-8
class Note < ActiveRecord::Base
	belongs_to :schedule

	scope :sort, -> (sn = "") { or_default(sn) }
  scope :or_default, -> (sn = "") { order("id desc") if sn.nil? || sn == "" }
  scope :has_schedule, -> (schedule_id) { where("schedule_id = ?", schedule_id) if schedule_id.to_i > 0 }
end
