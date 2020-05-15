# coding: utf-8
class Admin::OptionsController < Admin::ApplicationController
	inherit_resources

	before_filter :init_entity, only: [:update_fast]
	before_filter :init_entity_table, only: [:index, :update_fast]

	def index
		if privilege('see', 'options')
			@elements = Option.order("id asc")
		end
	end

	def update_fast
		if privilege('edit', 'options')
			if @option.update_attributes(option_params)
				entity_tr_html = render_to_string(partial: params[:partial], locals: {element: @option}, layout: false, formats: [:html], handlers: [:haml])
				render :json => { :status => "success", :entity_tr => entity_tr_html }
			else
				render :json => { :status => "error", :errors => @option.errors.messages }
			end
		end
	end

	private

	  def init_entity
	  	@option = Option.find(params[:id])
	  end

	  def option_params
	    params.require(:option).permit :val_param, :date_at
	  end

	  def init_entity_table
	  	@entity_table = 'options'
	  end
end
