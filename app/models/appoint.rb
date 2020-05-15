# coding: utf-8
class Appoint < ActiveRecord::Base
	belongs_to :user
	belongs_to :mentor, :class_name => 'User'
	belongs_to :moderator, :class_name => 'User'

	scope :sort, -> (sn = "") { or_default(sn) }
  scope :or_default, -> (sn = "") { order("id asc") if sn == "" || sn.nil? }
  scope :has_user, -> (user_id) { where("user_id = ?", user_id) }
  scope :has_mentor, -> (mentor_id) { where("mentor_id = ?", mentor_id) }
  scope :has_status, -> (status) { where("status = ?", status) }

  state_machine :status, initial: :current do
    state :current
    state :old

    event :sent_old do
      transition :current => :old
    end
  end
end
