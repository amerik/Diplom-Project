# coding: utf-8
class UserAchivmentsController < ApplicationController
	inherit_resources

	def get_slide
		if @user_current.auth?
			init_paginate(params[:per_page]) # @page, @per_page
			@user_achivments = @user_current.user_achivments.or_default.paginate(:per_page => @per_page, :page => @page)
	    @count_elements = @user_current.user_achivments.count
			get_pages_params(@page, @per_page, @count_elements) # @pages_params
			f1 = Filter.params_in_url(params.except(:authenticity_token, :utf8, :action, :controller, :page, :sort))
			@url = student_home_profiles_path + "?" + ([f1, '', 'page=']-['']).join('&')
			slide_html = render_to_string(partial: 'profiles/achievements', locals: {:user_achivments => @user_achivments, :per_page => @per_page, :user => User.find(params[:user_id].to_i)}, layout: false, formats: [:html], handlers: [:haml])
			render :json => { :status => "success", :slide => slide_html}	
		end
	end
end
