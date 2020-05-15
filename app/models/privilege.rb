# coding: utf-8
class Privilege < ActiveRecord::Base
	belongs_to :role

	extend Enumerize
	enumerize :page_name, in: %w(statistics users moderators mentors massages reviews notifications options meta_tags pages request_users categories page_helps), predicates: true
	enumerize :action_name, in: %w(see delete create answer export edit), predicates: true
end
