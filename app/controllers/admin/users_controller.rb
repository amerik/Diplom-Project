# coding: utf-8
class Admin::UsersController < Admin::ApplicationController
	inherit_resources

	before_filter :init_entity, only: [:update_fast, :destroy, :edit_moderator, :update, :edit, :edit_mentor, :download_passport, :set_status_register, :delete_account,
		:update_password, :shedule_mentor, :set_mentor]
	before_filter :init_entity_table, only: [:moderators, :index, :mentors, :edit_moderator, :new_moderator, :edit_mentor]

	has_scope :has_created_at_min, :has_created_at_max, :has_login, :has_id

	def authorization
		if params[:user][:login] != "" && params[:user][:password] != ""
			user_data = UserAuthFilter.authorization(User.new(user_params))
			if user_data.is_authorization?
				set_cookies_auth(user_data)
				# user_data.user_auth_stats << UserAuthStat.new
				render :json => { :status => "success", :url => admin_index_index_path(user_data) }
			else
				render :json => { :status => "error", :errors => [I18n.t("module.auth.login_input_error")] }
			end
		else
			render :json => { :status => "error", :errors => [I18n.t("module.auth.input_login")] }
		end
	end

	def moderators
		if privilege('see', 'moderators')
			init_paginate(30) # @page, @per_page
			@elements = apply_scopes(end_of_association_chain).by_moder.sort(params[:sort]).paginate(:per_page => @per_page, :page => @page)
	    @count_elements = apply_scopes(end_of_association_chain).by_moder.count
			get_pages_params(@page, @per_page, @count_elements) # @pages_params
			f1 = Filter.params_in_url(params.except(:authenticity_token, :utf8, :action, :controller, :page, :sort))
			@url = moderators_admin_users_path + "?" + ([f1, '', 'page=']-['']).join('&')
		end
	end

	def edit_moderator
		if privilege('edit', 'moderators')
		end
	end

	def new_moderator
		if privilege('create', 'moderators')
		end
	end

	def index
		if privilege('see', 'users')
			@user_admin = User.where("login = 'admin@gmail.com'").first
			init_paginate(30) # @page, @per_page
			@elements = apply_scopes(end_of_association_chain).has_role('client').sort(params[:sort]).paginate(:per_page => @per_page, :page => @page)
	    @count_elements = apply_scopes(end_of_association_chain).has_role('client').count
			get_pages_params(@page, @per_page, @count_elements) # @pages_params
			f1 = Filter.params_in_url(params.except(:authenticity_token, :utf8, :action, :controller, :page, :sort))
			@url = admin_users_path + "?" + ([f1, '', 'page=']-['']).join('&')
		end
	end

	def edit
		if privilege('edit', 'users')
			f1 = Filter.params_in_url(params.except(:authenticity_token, :utf8, :action, :controller, :page, :sort))
			@url = edit_admin_user_path(@user) + "?" + ([f1, '', 'page=']-['']).join('&')
		end
	end

	def new
		if privilege('create', 'users')
		end
	end

	def mentors
		if privilege('see', 'mentors')
			@user_admin = User.where("login = 'admin@gmail.com'").first
			init_paginate(30) # @page, @per_page
			@elements = apply_scopes(end_of_association_chain).has_role('mentor').sort(params[:sort]).paginate(:per_page => @per_page, :page => @page)
	    @count_elements = apply_scopes(end_of_association_chain).has_role('mentor').count
			get_pages_params(@page, @per_page, @count_elements) # @pages_params
			f1 = Filter.params_in_url(params.except(:authenticity_token, :utf8, :action, :controller, :page, :sort))
			@url = mentors_admin_users_path + f1 + "#{(f1 == '') ? '?' : '&'}page="
		end
	end

	def edit_mentor
		if privilege('edit', 'mentors')
		end
	end

	def new_mentor
		if privilege('create', 'mentors')
		end
	end

	def exit
		cookies.delete(:user_id)
		cookies.delete(:user_value)
		redirect_to admin_root_path
	end

	def update_fast
		if privilege('edit', @user.page_by_role_kind)
			if @user.update_attributes(user_params)
				@user.profile.update_attributes(profile_params)
				entity_tr_html = render_to_string(partial: params[:partial], locals: {element: @user}, layout: false, formats: [:html], handlers: [:haml])
				render :json => { :status => "success", :entity_tr => entity_tr_html }
			else
				render :json => { :status => "error", :errors => @user.errors.messages }
			end
		end
	end

	def destroy
		if privilege('delete', @user.page_by_role_kind)
			@user.destroy
			render :json => { :status => "success" }
		end
	end

	def destroy_checking
		unless params[:ids].nil?
			if privilege('delete', User.find(params[:ids].first.last.to_i).page_by_role_kind)
				params[:ids].each do |id|
					User.destroy(id.last.to_i)
				end
			end
			render :json => { :status => "success" }
		end
	end

	def update
		if privilege('edit', @user.page_by_role_kind)
			if @user.update_attributes(user_params)
				@user.profile.update_attributes(profile_params)
				render :json => { :status => "success", :url => request.headers["HTTP_REFERER"] }
			else
				render :json => { :status => "error", :errors => @user.errors.messages }
			end
		end
	end

	def create
		if privilege('create', User.new(:role_kind => params[:user][:role_kind]).page_by_role_kind)
			res = UserAuthFilter.add(User.new(user_params), params[:password_confirmation], Profile.new(profile_params))
			if res[:status] == 'success'
				user_new = res[:user]
	    	user_new.update_attribute(:status_register, true)
				render :json => { :status => "success", :url => edit_moderator_admin_user_path(user_new) }
			else
				render :json => { :status => "error", :errors => res[:errors] }
			end
		end
	end

	def download_passport
		if privilege('see', 'mentors')
			send_file @user.profile.passport_image.file.file, filename: @user.profile.passport_image.file.original_filename
		end
	end

	def set_status_register
		if privilege('edit', @user.page_by_role_kind)
			@user.update_attribute(:status_register, params[:status_register] == 'true')
			render :json => { :status => "success" }
		end
	end

	def update_password
		if privilege('edit', @user.page_by_role_kind)
			user_this = User.new(user_params)
			res = UserAuthFilter.set_password(user_this, '', true, @user)
			if res[:status] == 'success'
				render :json => { :status => "success", :url => request.headers["HTTP_REFERER"] }
			else
				render :json => { :status => "error", :errors => res[:errors] }
			end
		end
	end

	def shedule_mentor
		if privilege('see', 'mentors')
			init_paginate(100) # @page, @per_page
			@elements = @user.schedules_for_mentor.has_user(params[:has_user]).has_created_at_min(params[:has_created_at_min]).has_created_at_max(params[:has_created_at_max]).sort(params[:sort]).paginate(:per_page => @per_page, :page => @page)
	    @count_elements = @user.schedules_for_mentor.has_user(params[:has_user]).has_created_at_min(params[:has_created_at_min]).has_created_at_max(params[:has_created_at_max]).count
			get_pages_params(@page, @per_page, @count_elements) # @pages_params
			f1 = Filter.params_in_url(params.except(:authenticity_token, :utf8, :action, :controller, :page, :sort))
			@url = shedule_mentor_admin_user_path(@user) + "?" + ([f1, '', 'page=']-['']).join('&')
		end
	end

	def set_mentor
		if privilege('see', 'mentors')
			@user_admin = User.where("login = 'admin@gmail.com'").first
			@elements_search = apply_scopes(end_of_association_chain).has_role('mentor').by_specialization(@user.profile.specializations.or_default.first).uniq
			init_paginate(30) # @page, @per_page
			@elements = apply_scopes(end_of_association_chain).has_role('mentor').sort(params[:sort]).paginate(:per_page => @per_page, :page => @page)
	    @count_elements = apply_scopes(end_of_association_chain).has_role('mentor').count
			get_pages_params(@page, @per_page, @count_elements) # @pages_params
			f1 = Filter.params_in_url(params.except(:authenticity_token, :utf8, :action, :controller, :page, :sort))
			@url = set_mentor_admin_user_path(@user) + "?" + f1 + "#{(f1 == '') ? '?' : '&'}page="
		end
	end

	private

	  def init_entity
	  	@user = User.find(params[:id])
	  end

	  def user_params
	    params.require(:user).permit :login, :password, :salt, :access_token, :password_confirmation, :code_register, :status_register, 
	    	:role_kind, :role_id, :is_del, :del_description, :del_kind, :del_at, :del_moder_id, :is_del_email, :is_del_notification, :is_mentor_verification
	  end

	  def profile_params
	  	params[:user][:profile].permit :last_name, :first_name, :phone, :position, :image, :address, :passport, :gender, :birth_at, :email_work, :email_personal, 
	  		:phone_work, :phone_mobile_work, :phone_mobile_personal, :work_from_at, :head_position, :first_name_passport, :last_name_passport, :country_passport_id,
	  		:country_live_id, :expire_date_at, :zip, :street, :state, :city, :passport_image
	  end

	  def init_entity_table
	  	@entity_table = 'users'
	  end

	  def set_cookies_auth(user)
			cookies[:user_id] = { :value => user.id, :path => '/', :expires => 30.days.from_now }
			cookies[:user_value] = { :value => user.access_token, :path => '/', :expires => 30.days.from_now }
		end
end
