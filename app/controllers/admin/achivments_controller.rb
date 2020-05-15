# coding: utf-8
class Admin::AchivmentsController < Admin::ApplicationController
	inherit_resources

	before_filter :init_entity, only: [:update_fast, :update, :edit, :destroy]
	before_filter :init_entity_table, only: [:index, :edit, :new]

	has_scope :has_search

	def index
		if privilege('see', 'achivments')
			init_paginate(100) # @page, @per_page
			@elements = apply_scopes(end_of_association_chain).sort(params[:sort]).paginate(:per_page => @per_page, :page => @page)
	    @count_elements = apply_scopes(end_of_association_chain).count
			get_pages_params(@page, @per_page, @count_elements) # @pages_params
			f1 = Filter.params_in_url(params.except(:authentiachivment_token, :utf8, :action, :controller, :page, :sort))
			@url = admin_achivments_path + "?" + ([f1, '', 'page=']-['']).join('&')
		end
	end

	def update
		if privilege('edit', 'achivments')
			res = @achivment.update_with_fields(achivment_params, translation_params, nil, ['name'])
			if res[:status] == "success"
				render :json => { :status => "success", :url => request.headers["HTTP_REFERER"] }
			else
				render :json => { :status => "error", :errors => @achivment.errors.messages }
			end
		end
	end

	def update_fast
		if privilege('edit', 'achivments')
			res = @achivment.update_with_fields(achivment_params, translation_params, nil, ['name'])
			if res[:status] == "success"
			# if @achivment.update_attributes(achivment_params)
				entity_tr_html = render_to_string(partial: params[:partial], locals: {element: @achivment}, layout: false, formats: [:html], handlers: [:haml])
				render :json => { :status => "success", :entity_tr => entity_tr_html }
			else
				render :json => { :status => "error", :errors => @achivment.errors.messages }
			end
		end
	end

	def edit
		if privilege('edit', 'achivments')
		end
	end

	def new
		if @user_current.admin?
		else
			redirect_to admin_index_index_path
		end
	end

	def create
		if @user_current.auth_admin?
			achivment = Achivment.new.create_with_fields(achivment_params, translation_params, nil, ['name'])[:self]
			if achivment.save
				render :json => { :status => "success", :url => admin_achivments_path }
			else
				render :json => { :status => "error", :errors => achivment.errors.messages }
			end
		end
	end

	def destroy
		if @user_current.admin?
			@achivment.destroy
			render :json => { :status => "success" }
		end
	end

	def destroy_checking
		if @user_current.admin?
			unless params[:ids].nil?
				params[:ids].each do |id|
					Achivment.destroy(id.last.to_i)
				end
			end
			render :json => { :status => "success" }
		end
	end

	private

	  def init_entity
	  	@achivment = Achivment.find(params[:id])
	  end

	  def achivment_params
	    params.require(:achivment).permit :alias, :image
	  end

	  def translation_params
      params.require(:translation).permit :name, :description
    end

	  def init_entity_table
	  	@entity_table = 'achivments'
	  end
end
