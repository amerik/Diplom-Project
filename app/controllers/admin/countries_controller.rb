# coding: utf-8
class Admin::CountriesController < Admin::ApplicationController
	inherit_resources

	before_filter :init_entity, only: [:update_fast, :destroy, :update, :edit]
	before_filter :init_entity_table, only: [:index, :edit, :new]

	has_scope :has_search

	def index
		if privilege('see', 'settings')
			init_paginate(50) # @page, @per_page
			@elements = apply_scopes(end_of_association_chain).sort(params[:sort]).paginate(:per_page => @per_page, :page => @page)
	    @count_elements = apply_scopes(end_of_association_chain).count
			get_pages_params(@page, @per_page, @count_elements) # @pages_params
			f1 = Filter.params_in_url(params.except(:authenticity_token, :utf8, :action, :controller, :page, :sort))
			@url = admin_countries_path + "?" + ([f1, '', 'page=']-['']).join('&')
		end
	end

	def update
		if privilege('edit', 'settings')
			if @country.update_attributes(country_params)
				render :json => { :status => "success", :url => request.headers["HTTP_REFERER"] }
			else
				render :json => { :status => "error", :errors => @country.errors.messages }
			end
		end
	end

	def update_fast
		if @user_current.auth_admin?
			if @country.update_attributes(country_params)
				entity_tr_html = render_to_string(partial: params[:partial], locals: {element: @country}, layout: false, formats: [:html], handlers: [:haml])
				render :json => { :status => "success", :entity_tr => entity_tr_html }
			else
				render :json => { :status => "error", :errors => @country.errors.messages }
			end
		end
	end

	def create
		if privilege('create', 'settings')
			country = Country.new(country_params)
			if country.save
				render :json => { :status => "success", :url => admin_countries_path }
			else
				render :json => { :status => "error", :errors => country.errors.messages }
			end
		end
	end

	def destroy
		if @user_current.auth_admin?
			@country.destroy
			render :json => { :status => "success" }
		end
	end

	def destroy_checking
		if @user_current.auth_admin?
			unless params[:ids].nil?
				params[:ids].each do |id|
					Country.destroy(id.last.to_i)
				end
			end
			render :json => { :status => "success" }
		end
	end

	private

	  def init_entity
	  	@country = Country.find(params[:id])
	  end

	  def country_params
	    params.require(:country).permit :name_rus, :name_en
	  end

	  def init_entity_table
	  	@entity_table = 'countries'
	  end
end
