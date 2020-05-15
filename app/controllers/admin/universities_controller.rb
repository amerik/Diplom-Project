# coding: utf-8
class Admin::UniversitiesController < Admin::ApplicationController
	inherit_resources

	before_filter :init_entity, only: [:update_fast, :destroy, :update]
	before_filter :init_entity_table, only: [:index, :new, :edit]

	def index
		if @user_current.admin?
			init_paginate(30) # @page, @per_page
			@elements = apply_scopes(end_of_association_chain).sort(params[:sort]).paginate(:per_page => @per_page, :page => @page)
	    @count_elements = apply_scopes(end_of_association_chain).count
			get_pages_params(@page, @per_page, @count_elements) # @pages_params
			f1 = Filter.params_in_url(params.except(:authenticity_token, :utf8, :action, :controller, :page, :sort))
			@url = admin_universities_path + "?" + ([f1, '', 'page=']-['']).join('&')
		else
			redirect_to admin_index_index_path
		end
	end

	def update_fast
		if @user_current.admin?
			if @university.update_attributes(university_params)
				entity_tr_html = render_to_string(partial: params[:partial], locals: {element: @university}, layout: false, formats: [:html], handlers: [:haml])
				render :json => { :status => "success", :entity_tr => entity_tr_html }
			else
				render :json => { :status => "error", :errors => @university.errors.messages }
			end
		end
	end

	def new
		if @user_current.admin?
		else
			redirect_to admin_index_index_path
		end
	end

	def create
		if @user_current.admin?
			university = University.new(university_params)
			if university.save
				render :json => { :status => "success", :url => admin_universities_path }
			else
				render :json => { :status => "error", :errors => university.errors.messages }
			end
		end
	end

	def update
		if @user_current.admin?
			if @university.update_attributes(university_params)
				render :json => { :status => "success", :url => admin_universities_path }
			else
				render :json => { :status => "error", :errors => @university.errors.messages }
			end
		end
	end

	def destroy
		if @user_current.admin?
			@university.destroy
			render :json => { :status => "success" }
		end
	end

	def destroy_checking
		if @user_current.admin?
			unless params[:ids].nil?
				params[:ids].each do |id|
					University.destroy(id.last.to_i)
				end
			end
			render :json => { :status => "success" }
		end
	end

	private

	  def init_entity
	  	@university = University.find(params[:id])
	  end

	  def university_params
	    params.require(:university).permit :name, :position
	  end

	  def init_entity_table
	  	@entity_table = 'universities'
	  end
end
