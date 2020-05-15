# coding: utf-8
class TasksController < ApplicationController
	inherit_resources

	before_filter :init_entity, only: [:get_form_edit, :update, :destroy]

	def create
		if @user_current.mentor?
			task = Task.new(task_params)
			if task.save
				task_html = render_to_string(partial: 'tasks/items', locals: {:tasks => [task]}, layout: false, formats: [:html], handlers: [:haml])
				render :json => { :status => 'success', :task => task_html }
			else
				render :json => { :status => 'error', :errors => task.errors.messages }
			end
		end
	end

	def get_form_edit
		if @user_current.mentor?
			render :json => { :form_edit => render_to_string(partial: 'layouts/modals/edit_task_data', locals: {:task => @task}, layout: false, formats: [:html], handlers: [:haml]) }
		end
	end

	def update
		if @user_current.mentor?
			if @task.update_attributes(task_params)
				task_html = render_to_string(partial: 'tasks/items', locals: {:tasks => @task.schedule.tasks.or_default}, layout: false, formats: [:html], handlers: [:haml])
				render :json => { :status => 'success', :task => task_html }
			else
				render :json => { :status => 'error', :errors => @task.errors.messages }
			end
		end
	end

	def destroy
		if @user_current.mentor?
			@task.destroy
			render :json => { :status => 'success' }
		end
	end

	private

		def task_params
	    params.require(:task).permit :achivment_id, :description, :schedule_id
	  end

	  def init_entity
	  	@task = Task.find(params[:id])
	  end
end
