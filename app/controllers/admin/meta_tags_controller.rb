# coding: utf-8
class Admin::MetaTagsController < Admin::ApplicationController
	inherit_resources

	before_filter :init_entity, only: [:update_fast, :update, :edit]
	before_filter :init_entity_table, only: [:index, :edit]

	has_scope :has_search

	def index
		if privilege('see', 'meta_tags')
			init_paginate(30) # @page, @per_page
			@elements = apply_scopes(end_of_association_chain).where("attach_type = 'Page'").sort(params[:sort]).paginate(:per_page => @per_page, :page => @page)
	    @count_elements = apply_scopes(end_of_association_chain).where("attach_type = 'Page'").count
			get_pages_params(@page, @per_page, @count_elements) # @pages_params
			f1 = Filter.params_in_url(params.except(:authentimeta_tag_token, :utf8, :action, :controller, :page, :sort))
			@url = admin_meta_tags_path + "?" + ([f1, '', 'page=']-['']).join('&')
		end
	end

	def update
		if privilege('edit', 'meta_tags')
			res = @meta_tag.update_with_fields({}, translation_params, nil, ['title'])
			if res[:status] == "success"
				render :json => { :status => "success", :url => request.headers["HTTP_REFERER"] }
			else
				render :json => { :status => "error", :errors => @meta_tag.errors.messages }
			end
		end
	end

	def update_fast
		if privilege('edit', 'meta_tags')
			res = @meta_tag.update_with_fields({}, translation_params, nil, ['title'])
			if res[:status] == "success"
			# if @meta_tag.update_attributes(meta_tag_params)
				entity_tr_html = render_to_string(partial: params[:partial], locals: {element: @meta_tag}, layout: false, formats: [:html], handlers: [:haml])
				render :json => { :status => "success", :entity_tr => entity_tr_html }
			else
				render :json => { :status => "error", :errors => @meta_tag.errors.messages }
			end
		end
	end

	def edit
		if privilege('edit', 'meta_tags')
		end
	end

	private

	  def init_entity
	  	@meta_tag = MetaTag.find(params[:id])
	  end

	  def meta_tag_params
	    params.require(:meta_tag).permit :attach_id, :attach_type
	  end

	  def translation_params
      params.require(:translation).permit :title, :keywords, :description
    end

	  def init_entity_table
	  	@entity_table = 'meta_tags'
	  end
end
