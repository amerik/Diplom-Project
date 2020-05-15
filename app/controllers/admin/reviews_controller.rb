# coding: utf-8
class Admin::ReviewsController < Admin::ApplicationController
	inherit_resources

	before_filter :init_entity, only: [:update_fast, :update, :edit, :destroy]
	before_filter :init_entity_table, only: [:index, :edit, :new, :update_fast]

	has_scope :has_name, :has_location

	def index
		if privilege('see', 'partners')
			init_paginate(100) # @page, @per_page
			@elements = apply_scopes(end_of_association_chain).sort(params[:sort]).paginate(:per_page => @per_page, :page => @page)
	    @count_elements = apply_scopes(end_of_association_chain).count
			get_pages_params(@page, @per_page, @count_elements) # @pages_params
			f1 = Filter.params_in_url(params.except(:authentiachivment_token, :utf8, :action, :controller, :page, :sort))
			@url = admin_reviews_path + "?" + ([f1, '', 'page=']-['']).join('&')
		end
	end

	def edit
		if privilege('edit', 'partners')
		end
	end

	def update
		if privilege('edit', 'partners')
			res = @review.update_with_fields(review_params, translation_params, nil)
			if res[:status] == "success"
				render :json => { :status => "success", :url => admin_reviews_path }
			else
				render :json => { :status => "error", :errors => @review.errors.messages }
			end
		end
	end

	def update_fast
		if privilege('edit', 'partners')
			res = @review.update_with_fields(review_params, translation_params, nil)
			if res[:status] == "success"
				entity_tr_html = render_to_string(partial: params[:partial], locals: {element: @review}, layout: false, formats: [:html], handlers: [:haml])
				render :json => { :status => "success", :entity_tr => entity_tr_html }
			else
				render :json => { :status => "error", :errors => @review.errors.messages }
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
			review = Review.new.create_with_fields(review_params, translation_params, nil)[:self]
			if review.save
				render :json => { :status => "success", :url => admin_reviews_path }
			else
				render :json => { :status => "error", :errors => reviews.errors.messages }
			end
		end
	end

	def destroy
		if @user_current.admin?
			@review.destroy
			render :json => { :status => "success" }
		end
	end

	def destroy_checking
		if @user_current.auth_admin?
			unless params[:ids].nil?
				params[:ids].each do |id|
					Review.destroy(id.last.to_i)
				end
			end
			render :json => { :status => "success" }
		end
	end

	private

	  def init_entity
	  	@review = Review.find(params[:id])
	  end

	  def review_params
      params.require(:review).permit :image, :position, :user_id
    end

    def translation_params
      params.require(:translation).permit :name, :location, :description
    end

	  def init_entity_table
	  	@entity_table = 'reviews'
	  end	
end
