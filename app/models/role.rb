# coding: utf-8
class Role < ActiveRecord::Base
	has_many :privileges, :dependent => :destroy
	has_many :users

	scope :sort, -> (sn = "") { or_default(sn) }
  scope :or_default, -> (sn = "") { order("id asc") if sn.nil? || sn == "" }

  def is_privilege?(action_name, page_name)
  	Privilege.where("role_id = ? and action_name = ? and page_name = ?", self.id, action_name, page_name).count > 0
  end
end
