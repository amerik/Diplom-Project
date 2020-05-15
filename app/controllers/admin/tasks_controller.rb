# coding: utf-8
class Admin::TasksController < Admin::ApplicationController
	inherit_resources

	before_filter :init_entity, only: []
	before_filter :init_entity_table, only: [:index]

	has_scope :has_schedule

	def index
		if @user_current.admin?
			init_paginate(30) # @page, @per_page
			@elements = apply_scopes(end_of_association_chain).sort(params[:sort]).paginate(:per_page => @per_page, :page => @page)
	    @count_elements = apply_scopes(end_of_association_chain).count
			get_pages_params(@page, @per_page, @count_elements) # @pages_params
			f1 = Filter.params_in_url(params.except(:authenticity_token, :utf8, :action, :controller, :page, :sort))
			@url = admin_tasks_path + "?" + ([f1, '', 'page=']-['']).join('&')
		else
			redirect_to admin_index_index_path
		end
	end

	private

	  def init_entity
	  	@task = Task.find(params[:id])
	  end

	  def task_params
	    params.require(:task).permit :description
	  end

	  def init_entity_table
	  	@entity_table = 'tasks'
	  end
end
