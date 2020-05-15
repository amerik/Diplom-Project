# coding: utf-8
class Admin::NotificationsController < Admin::ApplicationController
	inherit_resources

	has_scope :has_search, :has_created_at_min, :has_created_at_max, :has_status

	def index
		if privilege('see', 'notifications')
			init_paginate(30) # @page, @per_page
			@elements = apply_scopes(end_of_association_chain).select("notifications.id, kind, description, DATE(notifications.created_at) as created_at_date, status, notifications.created_at, notifications.user_id, notifications.role").has_role('admin').order("created_at desc").paginate(:per_page => @per_page, :page => @page)
	    @count_elements = apply_scopes(end_of_association_chain).has_role('admin').count
			get_pages_params(@page, @per_page, @count_elements) # @pages_params
			f1 = Filter.params_in_url(params.except(:authenticity_token, :utf8, :action, :controller, :page, :sort))
			@url = admin_notifications_path + "?" + ([f1, '', 'page=']-['']).join('&')
		end
	end
end
