# coding: utf-8
class Admin::ApplicationController < ApplicationController
	layout 'admin/application'

	private

		# если все могут смотреть - не нужно писать в экшене
		def privilege(action_name, page_name)
			if @user_current.auth_admin?
				if @user_current.admin?
					true
				elsif @user_current.moderator?
					if Privilege.where("role_id = ? and action_name = ? and page_name = ?", @user_current.role_id.to_i, action_name, page_name).count > 0
						true
					else
						redirect_to moderator_privilege_admin_index_index_path
					end
				else
					redirect_to auth_admin_index_index_path
				end
			else
				redirect_to auth_admin_index_index_path
			end
		end
end