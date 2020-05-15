# coding: utf-8
class Admin::CitiesController < Admin::ApplicationController
	inherit_resources

	before_filter :init_entity, only: [:update_fast, :destroy, :update, :edit]
	before_filter :init_entity_table, only: [:index, :edit, :new]

	has_scope :has_search, :has_country

	def index
		if privilege('see', 'settings')
			init_paginate(100) # @page, @per_page
			@elements = apply_scopes(end_of_association_chain).sort(params[:sort]).paginate(:per_page => @per_page, :page => @page)
	    @count_elements = apply_scopes(end_of_association_chain).count
			get_pages_params(@page, @per_page, @count_elements) # @pages_params
			f1 = Filter.params_in_url(params.except(:authenticity_token, :utf8, :action, :controller, :page, :sort))
			@url = admin_cities_path + "?" + ([f1, '', 'page=']-['']).join('&')
			@country_select = Country.where("id = ?", params[:has_country].to_i).first
		end
	end

	def update
		if privilege('edit', 'settings')
			if @city.update_attributes(city_params)
				render :json => { :status => "success", :url => request.headers["HTTP_REFERER"] }
			else
				render :json => { :status => "error", :errors => @city.errors.messages }
			end
		end
	end

	def update_fast
		if @user_current.auth_admin?
			if @city.update_attributes(city_params)
				entity_tr_html = render_to_string(partial: params[:partial], locals: {element: @city}, layout: false, formats: [:html], handlers: [:haml])
				render :json => { :status => "success", :entity_tr => entity_tr_html }
			else
				render :json => { :status => "error", :errors => @city.errors.messages }
			end
		end
	end

	def create
		if privilege('create', 'settings')
			city = City.new(city_params)
			if city.save
				render :json => { :status => "success", :url => admin_cities_path }
			else
				render :json => { :status => "error", :errors => city.errors.messages }
			end
		end
	end

	def destroy
		if @user_current.auth_admin?
			@city.destroy
			render :json => { :status => "success" }
		end
	end

	def destroy_checking
		if @user_current.auth_admin?
			unless params[:ids].nil?
				params[:ids].each do |id|
					City.destroy(id.last.to_i)
				end
			end
			render :json => { :status => "success" }
		end
	end

	private

	  def init_entity
	  	@city = City.find(params[:id])
	  end

	  def city_params
	    params.require(:city).permit :name_rus, :name_en
	  end

	  def init_entity_table
	  	@entity_table = 'cities'
	  end
end
