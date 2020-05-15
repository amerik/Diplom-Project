# coding: utf-8
class Basket < ActiveRecord::Base
	belongs_to :user
	belongs_to :schedule
	belongs_to :payment

	scope :has_user, -> (user_id) { where("user_id = ?", user_id) }
	scope :has_schedule, -> (schedule_id) { where("schedule_id = ?", schedule_id) }
	scope :has_payment, -> (payment_id) { where("payment_id = ?", payment_id) }
	scope :has_status, -> (status) { where("status = ?", status) }
	scope :sort, -> (sn = "") { or_default(sn) }
  scope :or_default, -> (sn = "") { order("id asc") if sn == "" || sn.nil? }

	state_machine :status, initial: :new do
    state :new
    state :success

    event :sent_success do
      transition :new => :success
    end
  end
end
