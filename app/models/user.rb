# coding: utf-8
class User < ActiveRecord::Base
	class_attribute :current, :password_confirmation, :current_lan, :datetime_system, :hash_auto_fill, :time_auto_fill, :is_auth_admin

	belongs_to :role
	has_one :profile, :dependent => :destroy
	has_many :user_achivments, :dependent => :destroy
	has_many :schedules, :dependent => :destroy
	has_many :schedules_for_mentor, :dependent => :destroy, class_name: 'Schedule', foreign_key: 'mentor_id'
	has_many :baskets, :dependent => :destroy
	has_many :notifications, :dependent => :destroy
	has_many :reviews, :dependent => :destroy
	has_many :payments, :dependent => :destroy


	validates :login, email_format: { message: I18n.t("activerecord.errors.models.user.attributes.login.email_not_valid") }, uniqueness: { message: I18n.t("activerecord.errors.models.user.attributes.login.non_uniq_login") }
  validates :password, length: {minimum: 4, :message => I18n.t("activerecord.errors.models.user.attributes.password.too_short_pass")}
  validates :role_kind, :presence => true

  scope :by_not_guest, -> { where("role_kind != 'guest'") }
  scope :has_role, -> (value) { where :role_kind => value }
  scope :has_id, -> (value) { where :id => value }
  scope :by_login, -> (login) { where("lower(login) = lower(?)", login) }
  scope :has_login, -> (login) { where("lower(login) like lower(?)", "%#{login}%") }
  scope :by_moder, -> { where("role_kind = 'admin' or role_kind = 'moderator'") }
  scope :has_created_at_min, -> (date) { where("DATE(users.created_at) >= ?", date) }
  scope :has_created_at_max, -> (date) { where("DATE(users.created_at) <= ?", date) }
  scope :has_created_at, -> (dates) { where("DATE(users.created_at) >= ? and DATE(users.created_at) <= ?", dates['0'], dates['1']) if Filter.valid_datas?(dates) }
  scope :sort, -> (sn = "") { or_default(sn).or_login_a(sn).or_login_d(sn).or_last_name_a(sn).or_last_name_d(sn).or_updated_at_a(sn).or_updated_at_d(sn).or_created_at_a(sn).or_created_at_d(sn).or_is_mentor_verification_a(sn).or_is_mentor_verification_d(sn) }
  scope :or_default, -> (sn) { order("id desc") if sn.nil? || sn == "" }
  scope :or_login_a, -> (sn) { order("login asc") if sn == "order_login_asc" }
  scope :or_login_d, -> (sn) { order("login desc") if sn == "order_login_desc" }
  scope :or_last_name_a, -> (sn) { joins(:profile).order("profiles.last_name asc") if sn == "order_last_name_asc" }
  scope :or_last_name_d, -> (sn) { joins(:profile).order("profiles.last_name desc") if sn == "order_last_name_desc" }
  scope :or_updated_at_a, -> (sn) { order("users.updated_at asc") if sn == "order_updated_at_asc" }
  scope :or_updated_at_d, -> (sn) { order("users.updated_at desc") if sn == "order_updated_at_desc" }
  scope :or_created_at_a, -> (sn) { order("users.created_at asc") if sn == "order_created_at_asc" }
  scope :or_created_at_d, -> (sn) { order("users.created_at desc") if sn == "order_created_at_desc" }
  scope :or_is_mentor_verification_a, -> (sn) { joins(:profile).order("users.is_mentor_verification asc") if sn == "order_is_mentor_verification_asc" }
  scope :or_is_mentor_verification_d, -> (sn) { joins(:profile).order("users.is_mentor_verification desc") if sn == "order_is_mentor_verification_desc" }
  scope :has_online, -> (is_online) { has_online_true(is_online).has_online_false(is_online) }
  scope :has_online_true, -> (is_online = 'true') { where("users.online_at > ?", 1.minutes.ago) if is_online == 'true' }
  scope :has_online_false, -> (is_online = 'false') { where("users.online_at <= ?", 1.minutes.ago) if is_online == 'false' }
  scope :by_specialization, -> (specialization) { joins(:profile).joins("inner join specializations on specializations.profile_id = profiles.id").where("lower(specializations.name) in (?) or lower(specializations.company) in (?) or lower(specializations.industry) in (?) or lower(specializations.occupation) in (?)", specialization.name.mb_chars.downcase.to_s.split(' '), specialization.company.mb_chars.downcase.to_s.split(' '), specialization.industry.mb_chars.downcase.to_s.split(' '), specialization.occupation.mb_chars.downcase.to_s.split(' ')) unless specialization.nil? }
  scope :has_mentor_status, -> (mentor_status) { where("mentor_status = ?", mentor_status) }

  extend Enumerize
	enumerize :role_kind, in: %w(guest admin moderator client mentor), predicates: true

  state_machine :mentor_status, initial: :not_assigned do
    state :not_assigned
    state :requested
    state :assigned

    event :sent_request do
      transition :not_assigned => :requested
    end

    event :sent_assign do
      transition :requested => :assigned
    end  
      
    event :sent_not_assigned do
      transition all => :not_assigned
    end     
  end


	def client?
		self.role_kind == "client"
	end

	def mentor?
		self.role_kind == "mentor"
	end

	def admin?
		self.role_kind == "admin"
	end

	def moderator?
		self.role_kind == "moderator"
	end

	def auth?
		self.client? || self.mentor?
	end

	def auth_admin?
		self.admin? || self.moderator?
	end

	def online?
	  self.updated_at > 1.minutes.ago
	end

	def is_authorization?
		self.id.to_i > 0 #&& (self.uid.nil? || self.uid == "") # + доп. условия авторизации через &&
	end

	def page_by_role_kind
		if self.role_kind == 'admin' || self.role_kind == 'moderator'
			'moderators'
		elsif self.role_kind == 'client'
			'users'
		elsif self.role_kind == 'mentor'
			'mentors'
		end
	end

	def is_privilege?(action_name, page_name)
		if self.auth_admin?
			if self.admin?
				true
			elsif self.moderator?
				if Privilege.where("role_id = ? and action_name = ? and page_name = ?", self.role_id.to_i, action_name, page_name).count > 0
					true
				else
					false
				end
			else
				false
			end
		else
			false
		end
	end

	def self.get_message_admin
		User.where("login = 'admin@gmail.com'").first
	end

	def is_full_profile?
		self.step_profile >= 3
	end

	# назначенный ментор для студента
	def my_mentor
		appoint = Appoint.has_user(self.id).has_status('current').or_default.last
		unless appoint.nil?
			appoint.mentor
		else
			nil
		end
	end

	def my_students
		Appoint.has_mentor(self.id).has_status('current').or_default.map{|v| v.user}
	end

	def get_baskets
		self.baskets.has_status('new').or_default
	end

	def price_full
		unless self.my_mentor.nil?
			self.get_baskets.count * self.my_mentor.price
		else
			0
		end
	end

	# итоговая цена со скидкой
	def price_total
		unless self.my_mentor.nil?
			self.get_baskets.count * self.my_mentor.price - 0
		else
			0
		end
	end

	def get_schedule_current
		current = Schedule.has_user_by_role(self).where("start_at > ? and (status = 'is_pay' or status = 'in_work')", Time.now - 1.hours).or_default.first
		unless current.nil?
			if (current.start_at - 10.minutes) <= DateTime.now && current.start_at < (DateTime.now + 1.hours)
				current.sent_in_work if current.status != 'in_work'
				current
			else
				nil
			end
		else
			nil
		end
	end

	private

		def remove_user
			self.profile.delete unless self.profile.nil?
		end
end
