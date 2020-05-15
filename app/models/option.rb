# coding: utf-8
class Option < ActiveRecord::Base
	cattr_accessor :datetime_system

	def self.set_datetime_system
		DateTime.now
	end
end
