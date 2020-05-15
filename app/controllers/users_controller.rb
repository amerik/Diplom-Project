# coding: utf-8
class UsersController < ApplicationController
	inherit_resources
  before_filter :init_entity, only: [:update]
	
	def index
		if @user_current.client?
			if @user_current.is_full_profile?
				redirect_to student_home_profiles_path
			else
				redirect_to register_student_users_path
			end
		elsif @user_current.mentor?
			if @user_current.is_full_profile?
				redirect_to mentor_schedules_path
			else
				redirect_to register_mentor_users_path
			end
		else
			redirect_to root_path
		end
	end

	def register_mentor
		if @user_current.mentor?
		else
			redirect_to root_path
		end
	end

	def register_student
		if @user_current.client?
		else
			redirect_to root_path
		end
	end

	def register_role_kind
		p "=============#{@user_current.inspect}"

		if @user_current.is_full_profile?
			if @user_current.client?
				redirect_to student_home_profiles_path
			else
			  redirect_to mentor_schedules_path
			end
		end
	end

	def create
		if Filter.is_not_robot?(params[:hash_auto_fill], params[:time_auto_fill])
			res = UserAuthFilter.add(User.new(user_params), params[:password_confirmation], Profile.new)
			if res[:status] == 'success'
				user_new = res[:user]
				UserMailer.register(user_new).deliver_now
				render :json => { :status => "success", :message => "Thank you for registering! <br>You will receive a confirmation email shortly.", 
					:url => user_new.client? ? register_student_users_path : register_mentor_users_path }
			else
				render :json => { :status => "error", :errors => res[:errors] }
			end
		else
			render :json => { :status => "error", :errors => {:login => ['Confirm that you are not a robot']}, :code => 'recaptcha' }
		end
	end

	def check_register
		if !params[:id].nil? && !params[:code].nil?
			user = User.where("id = ? and code_register = ?", params[:id], params[:code]).last
			unless user.nil?
				user.update_attribute(:status_register, true)
				set_cookies_auth(user)
				redirect_to user.client? ? register_student_users_path : register_mentor_users_path
			else
				redirect_to root_path
			end
		else
			redirect_to root_path
		end
	end

	def authorization
		if params[:user][:login] != "" && params[:user][:password] != ""
			user_data = UserAuthFilter.authorization(User.new(user_params))
			user_check = User.by_login(params[:user][:login].strip).first
			if !user_check.nil?
				if user_data.is_authorization?
					set_cookies_auth(user_data)
					render :json => { :status => "success", :url => users_path }
				else
					render :json => { :status => "error", :errors => {:login => [I18n.t("module.auth.login_input_error")]} }
				end
			else
				render :json => { :status => "error", :errors => {:login => ['This e-mail is not registered']} }
			end
		else
			render :json => { :status => "error", :errors => {:login => [I18n.t("module.auth.input_login")]} }
		end
	end

	def soc_authorization
		st = ""

		params[:role_kind] = 'client' if params[:role_kind].nil?
		
		

		response = RestClient.get "http://ulogin.ru/token.php?token=#{params[:token]}&host=#{SITE_NAME_GLOBAL}"
		response = JSON.parse(response)

		user_data = User.where("network = ? and uid = ?", response['network'], response['uid']).first
		unless user_data.nil?
			set_cookies_auth(user_data)
			# p "=========++++===#{user_data.inspect}"
		else

			res = UserAuthFilter.add(User.new(:role_kind => params[:role_kind], :login => "#{response['uid']}@eleway.co.uk", :password => "113355"), "113355", Profile.new(:first_name =>  response['first_name'], :last_name => response['last_name']))
			if res[:status] == 'success'
				res[:user].update_attributes(:status_register => true, :network => response['network'], :uid => response['uid'])
				set_cookies_auth(res[:user])
			end
		end

		@user_current = UserAuthFilter.auth(cookies[:user_id], cookies[:user_value])
		# p "================#{@user_current.inspect}"
		
		if user_data.nil?
		  redirect_to register_role_kind_users_path
	  else
	  	redirect_to users_path
	  end

	end

	def exit
		cookies.delete(:user_id)
		cookies.delete(:user_value)
		redirect_to root_path
	end

	def update
		@user.update_attributes(user_params) unless params[:user].nil?
		render :json => { :status => "success", :url => users_path }
	end

	def request_mentor 
		if @user_current.client?
			@user_current.sent_request
			Notification.create(:name => "Mentor Request", :role => 'admin', :user_id => @user_current.id, :description => "Requested mentor by user:  #{@user_current.profile.decorate.full_name}", :kind => 'mentor_request')
			status_html = render_to_string(partial: 'profiles/mentor_status', locals: {:related =>'', :mentor_status =>  @user_current.mentor_status}, layout: false, formats: [:html], handlers: [:haml])
			render :json => { :status => "success", :status_html => status_html }
		else
			redirect_to root_path
		end
	end

	private

		def init_entity
	  	@user = User.find(params[:id])
	  end

	  def user_params
	    params.require(:user).permit :login, :password, :password_confirmation, :role_kind
	  end

	  def profile_params
	  	params[:user][:profile].permit :last_name, :first_name
	  end

	  def set_cookies_auth(user)
			cookies[:user_id] = { :value => user.id, :path => '/', :expires => 30.days.from_now }
			cookies[:user_value] = { :value => user.access_token, :path => '/', :expires => 30.days.from_now }
		end
end
