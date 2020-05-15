# coding: utf-8
class Admin::PagesController < Admin::ApplicationController
	inherit_resources

	before_filter :init_entity, only: [:update, :edit]
	before_filter :init_entity_table, only: [:index, :edit]

	def index
		if privilege('see', 'pages')
			init_paginate(100) # @page, @per_page
			@elements = apply_scopes(end_of_association_chain).sort(params[:sort]).paginate(:per_page => @per_page, :page => @page)
	    @count_elements = apply_scopes(end_of_association_chain).count
			get_pages_params(@page, @per_page, @count_elements) # @pages_params
			f1 = Filter.params_in_url(params.except(:authenticity_token, :utf8, :action, :controller, :page, :sort))
			@url = admin_pages_path + "?" + ([f1, '', 'page=']-['']).join('&')
		else
			redirect_to auth_admin_index_index_path
		end
	end

	def edit
		if privilege('see', 'edit')
		end
	end

	def update
		if privilege('see', 'edit')
			if @page.update_with_fields({}, translation_page_params)
				@page.meta_tag.update_with_fields({}, translation_params, nil, ['title'])
				render :json => { :status => "success", :url => admin_pages_path }
			else
				render :json => { :status => "error", :errors => @page.errors.messages }
			end
		end
	end

	private

	  def init_entity
	  	@page = Page.find(params[:id])
	  end

	  def translation_page_params
      params.require(:translation_page).permit :description, :h1
    end

    def translation_params
      params.require(:translation).permit :title, :keywords, :description
    end

	  def init_entity_table
	  	@entity_table = 'pages'
	  end
end
