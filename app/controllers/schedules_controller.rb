# coding: utf-8
class SchedulesController < ApplicationController
	inherit_resources

	before_filter :init_entity, only: [:update_tasks_notes_last, :check_end_lesson]

	def index
		redirect_to root_path
	end

	def mentor
		if @user_current.mentor?
			@month = DateTime.now.month
			@year = DateTime.now.year
			unless params[:month].nil?
				@month = params[:month].to_i
				@year = params[:year].to_i
			end
			@schedules = @user_current.schedules_for_mentor.by_month(@month, @year).or_default
			redirect_to current_videos_path if !@user_current.get_schedule_current.nil? && params[:is_forcibly].nil?
		else
			redirect_to root_path
		end
	end

	def reading_mentor
		if @user_current.mentor?
			dt = DateTime.new(params[:year].to_i, params[:month].to_i, params[:day].to_i, params[:hour].to_i, 0, 0) - @zone_interval.hours
			schedule = Schedule.by_date_hour(dt.year, dt.month, dt.day, dt.hour).first
			if schedule.nil?
				Schedule.create(:start_at => dt, :kind => 'hour_1', :mentor_id => @user_current.id)
				shedule_day = 'new'
			else
				schedule.destroy
				shedule_day = 'old'
			end
			render :json => { :status => "success", :shedule_day => shedule_day }
		end
	end

	def student
		if @user_current.client?
			@month = DateTime.now.month
			@year = DateTime.now.year
			unless params[:month].nil?
				@month = params[:month].to_i
				@year = params[:year].to_i
			end
			@my_mentor = @user_current.my_mentor
			@baskets = @user_current.get_baskets
			redirect_to current_videos_path if !@user_current.get_schedule_current.nil? && params[:is_forcibly].nil?
		else
			redirect_to root_path
		end
	end

	def search_mentor
	end

	# заказ уроков из корзины
	def set_user
		if @user_current.client?
			if @user_current.get_baskets.count > 0
				payment = Payment.create(:user_id => @user_current.id)
				@user_current.get_baskets.each do |basket|
					if basket.schedule.status == 'new'
						basket.schedule.sent_is_pay
						basket.schedule.update_attribute(:user_id, @user_current.id)
						basket.update_attribute(:payment_id, payment.id)
						basket.sent_success
					end
				end
				payment.sent_success
			end
			render :json => { :status => "success" }
		end
	end

	def my_students
		if @user_current.mentor?
			# init_paginate(5) # @page, @per_page
			# @user_achivments = @user_current.user_achivments.or_default.paginate(:per_page => @per_page, :page => 1)
	  #   @count_elements = @user_current.user_achivments.count
			# get_pages_params(@page, @per_page, @count_elements) # @pages_params
			# f1 = Filter.params_in_url(params.except(:authenticity_token, :utf8, :action, :controller, :page, :sort))
			# @url = student_home_profiles_path + "?" + ([f1, '', 'page=']-['']).join('&')
		else
			redirect_to root_path
		end
	end

	def my_mentor
		if @user_current.client?
			mentor_id = @user_current.my_mentor.id unless @user_current.my_mentor.nil?
			@chat = Chat.by_user_and_sender(@user_current.id, mentor_id).first
	    @chat = Chat.create(:user_first_id => @user_current.id, :user_second_id => mentor_id) if @chat.nil?
			@my_mentor = @user_current.my_mentor
		else
			redirect_to root_path
		end
	end

	def update_tasks_notes_last
		if @user_current.auth?
			tasks = @schedule.tasks.or_default
			notes = @schedule.notes.or_default
			tasks_html = render_to_string(partial: 'tasks/items', locals: {tasks: tasks}, layout: false, formats: [:html], handlers: [:haml])
			notes_html = render_to_string(partial: 'notes/items', locals: {notes: notes}, layout: false, formats: [:html], handlers: [:haml])
			render :json => { :status => "success", :tasks => tasks_html, :notes => notes_html }
		end
	end

	def check_end_lesson
		if @user_current.auth?
			if @schedule.status == 'success'
				render :json => { :status => "success", :reload => 'true' }
			else
				render :json => { :status => "success", :reload => 'false' }
			end
		end
	end

	private

		def init_entity
	  	@schedule = Schedule.find(params[:id])
	  end
end
