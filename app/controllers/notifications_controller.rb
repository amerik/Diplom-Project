# coding: utf-8
class NotificationsController < ApplicationController
	inherit_resources

	def get_notification_list
		if @user_current.auth?
			notifications = Notification.has_user(@user_current.id).has_role(@user_current.role_kind).has_status('not_read').or_default.limit(15)
			notifications_count = notifications.count
			notifications_html = render_to_string(partial: 'notifications/notification_item', locals: {notifications: notifications, notifications_count: notifications_count}, layout: false, formats: [:html], handlers: [:haml])
			render :json => { :status => "success", :notifications => notifications_html, :notifications_count => notifications_count }
		end		
	end

	def send_read_all
		if @user_current.auth?
			notifications = Notification.has_user(@user_current.id).has_role(@user_current.role_kind).has_status('not_read').or_default
			notifications.each do |notification|
				notification.sent_read
			end
			ender :json => { :status => "success"}
		end
	end
end
