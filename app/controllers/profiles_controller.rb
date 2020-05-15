# coding: utf-8
class ProfilesController < ApplicationController
	inherit_resources

	def student_home
		if @user_current.client?
			init_paginate(5) # @page, @per_page
			@user_achivments = @user_current.user_achivments.or_default.paginate(:per_page => @per_page, :page => 1)
	    @count_elements = @user_current.user_achivments.count
			get_pages_params(@page, @per_page, @count_elements) # @pages_params
			f1 = Filter.params_in_url(params.except(:authenticity_token, :utf8, :action, :controller, :page, :sort))
			@url = student_home_profiles_path + "?" + ([f1, '', 'page=']-['']).join('&')
			@notifications = @user_current.notifications.has_role(@user_current.role_kind).or_default.limit(100)
		else
			redirect_to root_path
		end
	end

	def student
		if @user_current.client?
			init_paginate(10) # @page, @per_page
			@user_achivments = @user_current.user_achivments.or_default.paginate(:per_page => @per_page, :page => 1)
	    @count_elements = @user_current.user_achivments.count
			get_pages_params(@page, @per_page, @count_elements) # @pages_params
			f1 = Filter.params_in_url(params.except(:authenticity_token, :utf8, :action, :controller, :page, :sort))
			@url = student_profiles_path + "?" + ([f1, '', 'page=']-['']).join('&')
		else
			redirect_to root_path
		end
	end

	def my_student
		@user_student = User.find(params[:user_id])
		if @user_current.mentor? && @user_student.my_mentor.id == @user_current.id
			init_paginate(10) # @page, @per_page
			@user_achivments = @user_current.user_achivments.or_default.paginate(:per_page => @per_page, :page => 1)
	    @count_elements = @user_current.user_achivments.count
			get_pages_params(@page, @per_page, @count_elements) # @pages_params
			f1 = Filter.params_in_url(params.except(:authenticity_token, :utf8, :action, :controller, :page, :sort))
			@url = student_profiles_path + "?" + ([f1, '', 'page=']-['']).join('&')


			@chat = Chat.by_user_and_sender(@user_current.id, @user_student.id).first
	    @chat = Chat.create(:user_first_id => @user_current.id, :user_second_id => @user_student.id) if @chat.nil?		
		else
			redirect_to root_path
		end
	end

	def mentor
		if @user_current.mentor?
			@notifications = @user_current.notifications.has_role(@user_current.role_kind).or_default.limit(100)
		else
			redirect_to root_path
		end
	end

	def faq
		if @user_current.auth?
      ids_str = params[:alias].split('-')
		  @categories = Category.has_kind(@user_current.role_kind).sort
		  @alias = ids_str[0]
		  category = Category.find(ids_str[1].to_i)
		  @page_helps = category.page_helps
	  end
	end

	def search_page_help
		if @user_current.auth?
			@page_helps = PageHelp.has_kind(params['kind']).by_search(params['has_search'])
			page_helps_html = render_to_string(partial: 'profiles/page_help', locals: {:elements => @page_helps}, layout: false, formats: [:html], handlers: [:haml])
			render :json => { :status => "success", :page_helps => page_helps_html}	
		end		
	end

	def student_edit
		if @user_current.client?
		else
			redirect_to root_path
		end
	end

	def mentor_edit
		if @user_current.mentor?
		else
			redirect_to root_path
		end
	end

	def update
		if @user_current.auth?
			is_valid = true
			unless params[:your_cv].nil?
				your_cv = Attachment.new(:kind => 'your_cv') do |a|
					a.file = params[:your_cv]
					a.attachable = @user_current.profile
				end

				is_valid = false if your_cv.get_type != "pdf" && your_cv.get_type != "doc"  && your_cv.get_type != "docx" && your_cv.get_type != "odt" && your_cv.get_type != "pages"
			end
			if is_valid
				if @user_current.profile.update_attributes(profile_params)
					@user_current.update_attributes(user_params) unless params[:user].nil?
					@user_current.profile.attachments << your_cv unless params[:your_cv].nil?
					unless params[:any_first].nil?
						@user_current.profile.attachments << Attachment.new(:kind => 'any_first') do |a|
							a.file = params[:any_first]
							a.attachable = @user_current.profile
						end
					end
					unless params[:any_second].nil?
						@user_current.profile.attachments << Attachment.new(:kind => 'any_second') do |a|
							a.file = params[:any_second]
							a.attachable = @user_current.profile
						end
					end
					unless params[:specializations].nil?
						ids = @user_current.profile.specializations.map{|v| v.id}
						params[:specializations].each do |item|
							specialization = item.last
							if specialization[:id].to_i > 0
								sp = Specialization.find(specialization[:id].to_i)
								sp.update_attributes(:name => specialization[:name], :company => specialization[:company], :industry => specialization[:industry], 
									:occupation => specialization[:occupation])
								ids.delete(sp.id)
							else
								@user_current.profile.specializations << Specialization.new(:name => specialization[:name], :company => specialization[:company], 
									:industry => specialization[:industry], :occupation => specialization[:occupation])
							end
						end
						ids.each do |sp_id|
							Specialization.delete(sp_id)
						end
						@user_current.update_attribute(:step_profile, params[:step_profile].to_i)
					end
					render :json => { :status => "success", :url => request.headers["HTTP_REFERER"] }
				else
					render :json => { :status => "error", :errors => @user_current.profile.errors.messages }
				end
			else
				render :json => { :status => "error", :errors => {:your_cv => ['File not expectable']} }
			end
		end
	end

	def del_your_cv
		if @user_current.auth?
			@user_current.profile.get_your_cv.destroy
			render :json => { :status => "success" }
		end
	end

	def del_any_first
		if @user_current.auth?
			@user_current.profile.get_any_first.destroy
			render :json => { :status => "success" }
		end
	end

	def del_any_second
		if @user_current.auth?
			@user_current.profile.get_any_second.destroy
			render :json => { :status => "success" }
		end
	end

	def check_social_url
		if @user_current.auth?
			status = 'error'
			if params[:soc] == 'fb_url' && (params[:url].include?("fb.com") || params[:url].include?("facebook.com"))
				begin
				  res = RestClient.get(params[:url])
				  status = 'success'
				rescue RestClient::ExceptionWithResponse => err
				end
			elsif params[:soc] == 'tw_url' && (params[:url].include?("twitter.com"))
				begin
				  res = RestClient.get(params[:url])
				  status = 'success'
				rescue RestClient::ExceptionWithResponse => err
				end
			elsif params[:soc] == 'inst_url' && (params[:url].include?("instagram.com"))
				begin
				  res = RestClient.get(params[:url])
				  status = 'success'
				rescue RestClient::ExceptionWithResponse => err
				end
			elsif params[:soc] == 'google_url' && (params[:url].include?("google.com"))
				begin
				  res = RestClient.get(params[:url])
				  status = 'success'
				rescue RestClient::ExceptionWithResponse => err
				end
			end
			render :json => { :status => status }
		end
	end

	def set_image
		if @user_current.auth?
			@user_current.profile.image = params[:image]
			@user_current.profile.save
			render :json => { :status => "success", :image => @user_current.profile.image_url('130x130', 'png') + "?#{Filter.get_random(10)}" }
		end
	end

	private

		def profile_params
	    params.require(:profile).permit :last_name, :first_name, :birth_at, :university_id, :year_of_study, :sex, :city_id, :degree, :fb_url, :tw_url, 
	    	:inst_url, :time_preference, :price_preference, :about_my, :motivational_letter, :additional_info, :google_url, :country_id
	  end

	  def user_params
	    params.require(:user).permit :step_profile
	  end
end
