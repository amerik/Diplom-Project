# coding: utf-8
class VideosController < ApplicationController
	inherit_resources

	def index
		if @user_current.auth?
			if @user_current.mentor?
			  redirect_to mentor_schedules_path
			else
				init_paginate(5) # @page, @per_page
				@schedule_current = @user_current.get_schedule_current
				
				@video_last = Video.has_status('ready').has_user_by_schedule(@user_current.id).last
		    @videos = Video.has_status('ready').has_user_by_schedule(@user_current.id).or_default.paginate(:per_page => @per_page, :page => 1)
		    @count_elements = @videos.count
				get_pages_params(@page, @per_page, @count_elements) # @pages_params
				f1 = Filter.params_in_url(params.except(:authenticity_token, :utf8, :action, :controller, :page, :sort))
				@url = videos_path + "?" + ([f1, '', 'page=']-['']).join('&')

				@today = DateTime.now.strftime('%d/%m/%Y')
				@week_before = 1.month.ago.strftime('%d/%m/%Y')
			end
		else
			redirect_to root_path
		end

	end

	def get_slide
		if @user_current.auth?
			init_paginate(params[:per_page]) # @page, @per_page
			
			@videos = Video.has_status('ready').has_user_by_schedule(@user_current.id).has_created_at_min(params[:has_created_at_min]).has_created_at_max(params[:has_created_at_max]).or_default.paginate(:per_page => @per_page, :page => @page)
	    @count_elements = @videos.count
			get_pages_params(@page, @per_page, @count_elements) # @pages_params
			f1 = Filter.params_in_url(params.except(:authenticity_token, :utf8, :action, :controller, :page, :sort))
			@url = student_home_profiles_path + "?" + ([f1, '', 'page=']-['']).join('&')
			slide_html = render_to_string(partial: 'videos/video_list', locals: {:videos => @videos, :per_page => @per_page}, layout: false, formats: [:html], handlers: [:haml])
			render :json => { :status => "success", :slide => slide_html}	
		end
	end

	def current
		if @user_current.auth?
			@schedule_current = @user_current.get_schedule_current
			unless @schedule_current.nil?
				if @schedule_current.status == 'in_work'
					@user_other = @user_current.client? ? @schedule_current.mentor : @schedule_current.user
					@chat = Chat.by_user_and_sender(@user_current.id, @user_other.id).first
			    @chat = Chat.create(:user_first_id => @user_current.id, :user_second_id => @user_other.id) if @chat.nil?
				  if @user_current.client?
				    @my_mentor = @user_current.my_mentor
				    @is_mentor = false
				  else
				  	@is_mentor = true
				  end	
				else
					if @user_current.client?
						redirect_to student_schedules_path
					else
						redirect_to mentor_schedules_path
					end
				end
			else
				if @user_current.client?
					redirect_to student_schedules_path
				else
					redirect_to mentor_schedules_path
				end
			end
		else
			redirect_to root_path
		end
	end

	def make_call
		if @user_current.auth?
			@schedule_current = @user_current.get_schedule_current
			if @user_current.mentor?
				calle_from = @schedule_current.mentor_id
				calle_to = @schedule_current.user_id
			else
				calle_from = @schedule_current.user_id
				calle_to = @schedule_current.mentor_id
			end
			if @schedule_current.status_call == 'new'
			  file = "call_#{@schedule_current.id}_#{DateTime.now.strftime('%m-%d-%y_%H:%M:%S')}"
			  @video_caller = Video.create(:schedule_id => @schedule_current.id, :user_id => calle_from, :file => file)
			  @schedule_current.sent_calling
			  render :json => { :status => "success", :file => file }
		  else
		  	render :json => { :status => "error", :msg => 'Error ! you have unlosed call session. Do you want to close it ?' }
		  end
		end
	end

	def call_hangup
		if @user_current.auth?
			@schedule_current = @user_current.get_schedule_current
			if params['type'] == 'cancel'
			  @schedule_current.sent_cancel_call unless @schedule_current.nil?
			else
			  @schedule_current.sent_reset_call unless @schedule_current.nil?
			end
			render :json => { :status => "success", :room => @schedule_current.id }
		end
	end

	def check_is_call
		if @user_current.auth?
			user_has_call = false
		  schedule_current = @user_current.get_schedule_current 
		  
		  last_call = schedule_current.videos.last unless schedule_current.nil? 
		  if schedule_current.status_call == 'calling'
		    if last_call.user_id != @user_current.id
		  	  user_has_call = true
		    end
		  end
		  render :json => { :status => "success", :user_has_call => user_has_call }
		end
	end

	def answer_to_call
		if @user_current.auth?
			@schedule_current = @user_current.get_schedule_current
			if @schedule_current.status_call == 'calling'
			  @schedule_current.sent_accepted unless @schedule_current.nil?
			  render :json => { :status => "success"}
			else
				render :json => { :status => "error", :msg => 'Error ! you are already in call session.' }
			end
		end
	end

	def get_call_status
		if @user_current.auth?
			schedule_current = @user_current.get_schedule_current
			status_call =  schedule_current.status_call  unless schedule_current.nil?
			if status_call == 'accepted'
	      video = schedule_current.videos.last.file unless schedule_current.nil?
			end
			render :json => { :status => "success", :call_status => status_call, :file => video  }
		end
	end

	def video_call_block
		if @user_current.auth?
			user_other = User.find(params[:user_other])
			chat = Chat.find(params[:chat])
			schedule_current = @user_current.get_schedule_current 
			video_html = render_to_string(partial: 'videos/video_call', locals: {:user_other => user_other, :chat => chat}, layout: false, formats: [:html], handlers: [:haml])
			render :json => { :status => "success", :video_html => video_html}	
		end
	end
end
