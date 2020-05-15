# coding: utf-8
class Notification < ActiveRecord::Base
	belongs_to :user

	scope :by_not_read, -> { where("status = 'not_read'") }
	scope :has_kind, -> (kind) { where("kind = ?", kind) }
	scope :has_user, -> (user_id) { where("user_id = ?", user_id) }
	scope :has_role, -> (role) { where("notifications.role = ?", role) }
	scope :has_status, -> (status) { where("status = ?", status) }
	scope :has_created_at_min, -> (date) { where("DATE(notifications.created_at) >= ?", date) }
  scope :has_created_at_max, -> (date) { where("DATE(notifications.created_at) <= ?", date) }
  scope :has_search, -> (text) { joins(:user).joins("inner join profiles on profiles.user_id = users.id").where("lower(users.login) like lower(?) or users.id = ? or lower(profiles.last_name) like lower(?) or lower(profiles.first_name) like lower(?)", "%#{text}%", text.to_i, "%#{text}%", "%#{text}%") }
  scope :sort, -> (sn = "") { or_default(sn) }
  scope :or_default, -> (sn = "") { order("id desc") if sn.nil? || sn == "" }

	extend Enumerize
	enumerize :kind, in: %w(new_session mentor_request), predicates: true
	enumerize :role, in: %w(admin mentor client), predicates: true

	state_machine :status, initial: :not_read do
    state :not_read
    state :read

    event :sent_read do
      transition :not_read => :read
    end
  end
end
