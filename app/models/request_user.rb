# coding: utf-8
class RequestUser < ActiveRecord::Base
	scope :sort, -> (sn = "") { or_default(sn) }
  scope :or_default, -> (sn = "") { order("id desc") if sn.nil? || sn == "" }
  
	validates :email, email_format: { message: I18n.t("activerecord.errors.models.user.attributes.login.email_not_valid") }, uniqueness: { message: I18n.t("activerecord.errors.models.user.attributes.login.non_uniq_login") }
end
