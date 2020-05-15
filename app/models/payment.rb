# coding: utf-8
class Payment < ActiveRecord::Base
	belongs_to :user
	has_many :baskets, :dependent => :destroy
	
	state_machine :status, initial: :new do
    state :new
    state :success

    event :sent_success do
      transition :current => :success
    end
  end
end
