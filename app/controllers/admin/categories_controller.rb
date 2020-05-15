# coding: utf-8
class Admin::CategoriesController < Admin::ApplicationController
	inherit_resources

	before_filter :init_entity, only: [:update_fast, :update, :edit, :destroy]
	before_filter :init_entity_table, only: [:index, :edit, :new, :update_fast]

	has_scope :has_kind

	def index
		if privilege('see', 'categories')
			init_paginate(100) # @page, @per_page
			@elements = apply_scopes(end_of_association_chain).sort(params[:sort]).paginate(:per_page => @per_page, :page => @page)
	    @count_elements = apply_scopes(end_of_association_chain).count
			get_pages_params(@page, @per_page, @count_elements) # @pages_params
			f1 = Filter.params_in_url(params.except(:authentiachivment_token, :utf8, :action, :controller, :page, :sort))
			@url = admin_categories_path + "?" + ([f1, '', 'page=']-['']).join('&')
		end
	end

	def edit
		if privilege('edit', 'categories')
		end
	end

	def update
		if privilege('edit', 'categories')
			res = @category.update_with_fields(category_params, translation_params, nil)
			if res[:status] == "success"
				render :json => { :status => "success", :url => admin_categories_path }
			else
				render :json => { :status => "error", :errors => @category.errors.messages }
			end
		end
	end

	def update_fast
		if privilege('edit', 'categories')
			res = @category.update_with_fields(category_params, translation_params, nil)
			if res[:status] == "success"
				entity_tr_html = render_to_string(partial: params[:partial], locals: {element: @category}, layout: false, formats: [:html], handlers: [:haml])
				render :json => { :status => "success", :entity_tr => entity_tr_html }
			else
				render :json => { :status => "error", :errors => @category.errors.messages }
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
		if @user_current.auth_admin?
			category = Category.new.create_with_fields(category_params, translation_params, nil)[:self]
			if category.save
				render :json => { :status => "success", :url => admin_categories_path }
			else
				render :json => { :status => "error", :errors => category.errors.messages }
			end
		end
	end

	def destroy
		if @user_current.admin?
			@category.destroy
			render :json => { :status => "success" }
		end
	end

	def destroy_checking
		if @user_current.auth_admin?
			unless params[:ids].nil?
				params[:ids].each do |id|
					Category.destroy(id.last.to_i)
				end
			end
			render :json => { :status => "success" }
		end
	end

	private

	  def init_entity
	  	@category = Category.find(params[:id])
	  end

	  def category_params
      params.require(:category).permit :kind, :alias, :position
    end

    def translation_params
      params.require(:translation).permit :name
    end

	  def init_entity_table
	  	@entity_table = 'categories'
	  end	
end
