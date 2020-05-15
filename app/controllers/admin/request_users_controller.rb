# coding: utf-8
class Admin::RequestUsersController < Admin::ApplicationController
	inherit_resources

	before_filter :init_entity_table, only: [:index]

	def index
		if privilege('see', 'request_users')
			init_paginate(30) # @page, @per_page
			@elements = apply_scopes(end_of_association_chain).sort(params[:sort]).paginate(:per_page => @per_page, :page => @page)
	    @count_elements = apply_scopes(end_of_association_chain).count
			get_pages_params(@page, @per_page, @count_elements) # @pages_params
			f1 = Filter.params_in_url(params.except(:authentimeta_tag_token, :utf8, :action, :controller, :page, :sort))
			@url = admin_request_users_path + "?" + ([f1, '', 'page=']-['']).join('&')
		end
	end

	private

		def init_entity_table
	  	@entity_table = 'request_users'
	  end
end
