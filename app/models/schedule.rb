# coding: utf-8
class Schedule < ActiveRecord::Base
	belongs_to :user
	belongs_to :mentor, :class_name => 'User'
  has_many :tasks, :dependent => :destroy
  has_many :notes, :dependent => :destroy
  has_many :baskets, :dependent => :destroy
  has_many :videos, :dependent => :destroy

  scope :sort, -> (sn = "") { or_default(sn) }
  scope :or_default, -> (sn = "") { order("start_at asc") if sn.nil? || sn == "" }
  scope :has_user, -> (user_id, role = 'client') { where("user_id = ?", user_id) if user_id.to_i > 0 && role == 'client' }
  scope :has_mentor, -> (user_id, role = 'mentor') { where("mentor_id = ?", user_id) if user_id.to_i > 0 && role == 'mentor' }
  scope :has_user_by_role, -> (user) { has_user(user.id, user.role_kind).has_mentor(user.id, user.role_kind) }
  scope :has_created_at_min, -> (date) { where("DATE(schedules.start_at) >= ?", date) if !date.nil? && date != "" }
  scope :has_created_at_max, -> (date) { where("DATE(schedules.start_at) <= ?", date) if !date.nil? && date != "" }
  scope :by_month, -> (month, year) { where("EXTRACT(MONTH FROM schedules.start_at) = ? and EXTRACT(YEAR FROM schedules.start_at) = ?", month, year) }
  scope :by_date_hour, -> (year, month, day, hour) { by_month(month, year).has_day(day).where("EXTRACT(HOUR FROM schedules.start_at) = ? and kind = 'hour_1'", hour) }
  scope :has_day, -> (day) { where("EXTRACT(DAY FROM schedules.start_at) = ?", day) }
  scope :has_status, -> (status) { where("status = ?", status) }
  scope :has_status_call, -> (status_call) { where("status_call = ?", status_call) }  
  scope :has_start_at_date, -> (date) { where("DATE(start_at) = DATE(?)", date) }
  scope :by_in_work, -> { where("status in (?)", %w(is_pay in_work success)) }

	extend Enumerize
	enumerize :kind, in: %w(hour_1), predicates: true

	state_machine :status, initial: :new do
    state :new
    state :is_pay
    state :in_work
    state :success
    state :cancel

    event :sent_is_pay do
      transition :new => :is_pay
    end

    event :sent_in_work do
      transition :is_pay => :in_work
    end

    event :sent_success do
      transition :in_work => :success
    end

    event :sent_cancel do
      transition all => :cancel
    end
  end

  state_machine :status_call, initial: :new do
    state :new
    state :calling
    state :accepted
    state :canceled

    event :sent_calling do
      transition :new => :calling
    end

    event :sent_accepted do
      transition :calling => :accepted
    end

    event :sent_reset_call do
      transition :canceled => :new
    end

    event :sent_cancel_call do
      transition all => :canceled
    end        
  end  
end
