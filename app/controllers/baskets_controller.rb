# coding: utf-8
class BasketsController < ApplicationController
	inherit_resources

	before_filter :init_entity, only: [:destroy]

	def create
		if @user_current.client?
			@month = params[:month].to_i
			@year = params[:year].to_i
			day_this = params[:day].to_i
			@my_mentor = @user_current.my_mentor
			basket = Basket.new(basket_params)
			basket.user = @user_current
			if basket.save
				basket_html = render_to_string(partial: 'baskets/items', locals: {:baskets => [basket]}, layout: false, formats: [:html], handlers: [:haml])
				item_day_html = render_to_string(partial: 'schedules/item_day', locals: {:day_this => day_this}, layout: false, formats: [:html], handlers: [:haml])
				render :json => { :status => "success", :basket => basket_html, :item_day => item_day_html }
			else
				render :json => { :status => "error", :errors => basket.errors.messages }
			end
		end
	end

	def destroy
		if @user_current.client? && @user_current.id == @basket.user_id
			@basket.destroy
			@month = params[:month].to_i
			@year = params[:year].to_i
			day_this = params[:day].to_i
			@my_mentor = @user_current.my_mentor
			item_day_html = render_to_string(partial: 'schedules/item_day', locals: {:day_this => day_this}, layout: false, formats: [:html], handlers: [:haml])
			render :json => { :status => "success", :item_day => item_day_html }
		end
	end

	def del_all_new_baskets
		if @user_current.client?
			@user_current.get_baskets.delete_all
			render :json => { :status => "success" }
		end
	end

	private

		def init_entity
	  	@basket = Basket.find(params[:id])
	  end

	  def basket_params
	    params.require(:basket).permit :schedule_id
	  end
end
