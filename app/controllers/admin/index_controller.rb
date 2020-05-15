# coding: utf-8
class Admin::IndexController < Admin::ApplicationController
	def index
		if @user_current.auth_admin?
			if @user_current.auth_admin?
				redirect_to admin_users_path
			else
				redirect_to moderator_privilege_admin_index_index_path
			end
		else
			redirect_to auth_admin_index_index_path
		end
	end

	def moderator_privilege
		if @user_current.auth_admin?
		else
			redirect_to auth_admin_index_index_path
		end
	end

	def auth
		@meta_title = I18n.t("view.admin.index.title_auth")
	end

	def auth_all
		@meta_title = I18n.t("view.admin.index.title_auth")
	end

	def settings
	end

	def notifications
	end
end