# coding: utf-8
class Admin::PrivilegesController < Admin::ApplicationController
	before_filter :init_role, only: [:index, :set_role]

	def index
		if @user_current.admin?
		end
	end

	def set_role
		if @user_current.admin?
			unless params[:privileges].nil?
				@role.privileges.delete_all
				params[:privileges].each do |privilege|
					privilege.last.each do |page_name|
						@role.privileges << Privilege.new(:page_name => page_name.first, :action_name => privilege.first) if page_name.last == 'true'
					end
				end
			end
			render :json => { :status => "success", :url => admin_privileges_path(:role_id => @role.id) }
		end
	end

	private

	  def init_role
	  	@role = Role.find(params[:role_id])
	  end
end
