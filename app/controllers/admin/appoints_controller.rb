# coding: utf-8
class Admin::AppointsController < Admin::ApplicationController
	inherit_resources

	def create
		if @user_current.auth_admin?
			old_appoints = Appoint.has_user(appoint_params[:user_id]).sort
			if old_appoints.count > 0
				old_appoints.each do |old_appoint|
					old_appoint.update_attributes(:status => 'old')
				end
			end

			appoint = Appoint.new(appoint_params)
			appoint.moderator = @user_current
			user = User.find(appoint_params[:user_id])
			user.sent_assign
			Notification.create(:name => "Mentor Appointed", :role => 'client', :user_id => appoint_params[:user_id], :description => "#{User.find(appoint_params[:mentor_id]).profile.decorate.full_name} Appointed as a mentor for you", :kind => 'mentor_request')
			Notification.create(:name => "Mentor Appointed", :role => 'mentor', :user_id => appoint_params[:mentor_id], :description => "You have been appointed as Mentor for:  #{user.profile.decorate.full_name}", :kind => 'mentor_request')
			if appoint.save
				render :json => { :status => "success" }
			else
				render :json => { :status => "error", :errors => appoint.errors.messages }
			end
		end
	end

	def change_mentor
		if @user_current.client?
			appoint = Appoint.has_user(appoint_params[:user_id]).last
			appoint.update_attributes(:status => 'old')
			@user_current.sent_not_assigned
			@user_current.sent_request
			Notification.create(:name => "Mentor Request", :role => 'admin', :user_id => @user_current.id, :description => "Requested change mentor by user:  #{@user_current.profile.decorate.full_name}", :kind => 'mentor_request')
			render :json => { :status => "success" }
		end		
	end

	private

	  def appoint_params
	    params.require(:appoint).permit :user_id, :mentor_id
	  end
end
