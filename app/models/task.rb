# coding: utf-8
class Task < ActiveRecord::Base
	belongs_to :schedule
	belongs_to :achivment
	has_many :user_achivments, :dependent => :destroy

	scope :sort, -> (sn = "") { or_default(sn) }
  scope :or_default, -> (sn = "") { order("id desc") if sn.nil? || sn == "" }
  scope :has_schedule, -> (schedule_id) { where("schedule_id = ?", schedule_id) if schedule_id.to_i > 0 }

  validates :description, :achivment_id, :presence => true

  state_machine :status, initial: :new do
    state :new
    state :success

    event :sent_success do
      transition :new => :success
    end
  end
end
