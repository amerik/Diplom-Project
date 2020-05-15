# coding: utf-8
class Video < ActiveRecord::Base
	belongs_to :schedule

	scope :sort, -> (sn = "") { or_default(sn) }
  scope :or_default, -> (sn = "") { order("id desc") if sn.nil? || sn == "" }
  scope :has_user, -> (user_id) { where("user_id = ?", user_id) if user_id.to_i > 0 }	
  scope :has_status, -> (status) { where("videos.status = ?", status) }
  scope :has_user_by_schedule, -> (user_id) { joins(:schedule).where("schedules.user_id = ?", user_id) }
  scope :has_created_at_min, -> (date) { where("DATE(videos.created_at) >= ?", date) }
  scope :has_created_at_max, -> (date) { where("DATE(videos.created_at) <= ?", date) }
  
  state_machine :status, initial: :new do
    state :new
    state :reading
    state :ready
    state :error

    event :sent_reading do
      transition :new => :reading
    end

    event :sent_ready do
      transition :reading => :ready
    end      

    event :sent_error do
      transition all => :error
    end     
  end 
end
