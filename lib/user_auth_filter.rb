# coding: utf-8
module UserAuthFilter
	require 'digest/md5'

	def self.hash_value(login, pass, salt)
		code = Digest::MD5.hexdigest(login + pass + salt + 'jds89hs9&^#%@vbu99v3bo@~~sb9uvbw9H$TT$82bss8576hj80g3j0iwn0g2djvh32')

		0.upto(5) do |i|
			code = Digest::MD5.hexdigest(code)
		end

		code
	end

	def self.hash_pass(pass, salt)
		code = Digest::MD5.hexdigest(pass + salt + 'jds89hs9&^#%@vbu99v3bo@~~sb9uvbw9H$TT$82bss8576hj80g3j0iwn0g2djvh32')
		
		0.upto(5) do |i|
			code = Digest::MD5.hexdigest(code)
		end
		
		code
	end

	def self.get_clear_integer(str)
		value = ""
		str.chars do |ch|
			0.upto(9) do |val|
				if ch == val.to_s
					value += ch
					break
				end
			end
		end
		value
	end

	# возвращается в случае успешной авторизации
	def self.auth(user_id, user_value)
		user = User.where(:id => user_id).first
		unless user.nil?
			if user_value == user.access_token
				user
			else
				User.new
			end
		else
			User.new
		end
	end

	def self.authorization(user_this)
		user = User.select("id, salt, password, role_kind, access_token, status_register").by_login(user_this.login.strip).first
		unless user.nil?
			if user.password == UserAuthFilter.hash_pass(user_this.password.strip, user.salt) && user.status_register #&& !user.is_del
				user
			else
				User.new
			end
		else
			User.new
		end
	end

	def self.add(user_this, password_confirmation, profile, is_soc = false)
		user_this.profile = profile
		res = UserAuthFilter.valid_create(user_this, password_confirmation, profile, is_soc = false)
		if res[:status] == "success"
			user_this = UserAuthFilter.set_auth(user_this)
			user_this.code_register = Filter.get_random(30)
			unless user_this.salt.nil?
				user_this.save
				{:status => "success", :user => user_this}
			else
				{:status => "error", :errors => {:password => [I18n.t("module.auth.system_error")]}}
			end
		else
			{:status => res[:status], :errors => res[:errors]}
		end
	end

	def self.valid_create(user_this, password_confirmation, profile, is_soc = false)
		user_this.profile = profile
		if user_this.valid?
			is_other_field = true
			if is_other_field
				if User.where("lower(login) = lower(?)", user_this.login).size == 0 || is_soc # проверка на совпадение из БД
					if user_this.password == password_confirmation
						{:status => "success"}
					else
						{:status => "not_confirmation_password", :errors => {:password => [I18n.t("activerecord.errors.models.user.attributes.password.not_confirmation_password")]}}
					end
				else
					{:status => "non_uniq_login", :errors => {:login => [I18n.t("activerecord.errors.models.user.attributes.login.non_uniq_login")]}}
				end
			else
				errors = Hash.new
				errors[:profile_last_name] = [I18n.t("activerecord.errors.models.profile.attributes.last_name.blank")] if user_this.profile.last_name == ""
				errors[:profile_first_name] = [I18n.t("activerecord.errors.models.profile.attributes.first_name.blank")] if user_this.profile.first_name == ""
				{:status => "null_profile", :errors => errors}
			end
		else
			{:status => "not_confirmation_password", :errors => user_this.errors.messages}
		end
	end

	def self.set_password(user_this, old_password, is_not_check_old_pass = false, user_set = nil)
		user_set = @user_current if user_set.nil?
		if user_this.password == user_this.password_confirmation && user_this.password.length > 4
			if user_set.password == UserAuthFilter.hash_pass(old_password.strip, user_set.salt) || is_not_check_old_pass
				user_set.password = user_this.password
				user_set.password_confirmation = user_this.password_confirmation
				user = UserAuthFilter.set_auth(user_set)
				user.save
				{:status => "success", :user => user}
			else
				if user_this.password.length <= 4
					{:status => "error", :errors => {:password => [I18n.t("module.auth.error_small_password")]}}
				else
					{:status => "error", :errors => {:set_old_password => [I18n.t("module.auth.error_old_password")]}}
				end
			end
		else
			{:status => "error", :errors => {:password => [I18n.t("activerecord.errors.models.user.attributes.password.not_confirmation_password")]}}
		end
	end

	protected

		# задаются аутентификационные данные
		def self.set_auth(user_this)
			user_this.salt = Filter.get_random(20)
			password_hash = UserAuthFilter.hash_pass(user_this.password, user_this.salt)
			user_this.access_token = UserAuthFilter.hash_value(user_this.login, password_hash, user_this.salt)
			user_this.password = password_hash
			user_this
		end
end