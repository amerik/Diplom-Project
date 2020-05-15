# coding: utf-8
class RequestUsersController < ApplicationController
	inherit_resources

	def create
		request_user = RequestUser.new(request_user_params)
		if request_user.save
			render :json => { :status => "success", :message => "Thank you! You have successfully subscribed" }
		else
			render :json => { :status => "error", :errors => request_user.errors.messages, :entity => 'request_user' }
		end
	end

	private

	  def request_user_params
	    params.require(:request_user).permit :email
	  end
end
