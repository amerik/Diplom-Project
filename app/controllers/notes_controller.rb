# coding: utf-8
class NotesController < ApplicationController
	inherit_resources

	before_filter :init_entity, only: [:get_form_edit, :update, :destroy]

	def create
		if @user_current.mentor?
			note = Note.new(note_params)
			if note.save
				note_html = render_to_string(partial: 'notes/items', locals: {:notes => [note]}, layout: false, formats: [:html], handlers: [:haml])
				render :json => { :status => 'success', :note => note_html }
			else
				render :json => { :status => 'error', :errors => note.errors.messages }
			end
		end
	end

	def get_form_edit
		if @user_current.mentor?
			render :json => { :form_edit => render_to_string(partial: 'layouts/modals/edit_note_data', locals: {:note => @note}, layout: false, formats: [:html], handlers: [:haml]) }
		end
	end

	def update
		if @user_current.mentor?
			if @note.update_attributes(note_params)
				note_html = render_to_string(partial: 'notes/items', locals: {:notes => @note.schedule.notes.or_default}, layout: false, formats: [:html], handlers: [:haml])
				render :json => { :status => 'success', :note => note_html }
			else
				render :json => { :status => 'error', :errors => @note.errors.messages }
			end
		end
	end

	def destroy
		if @user_current.mentor?
			@note.destroy
			render :json => { :status => 'success' }
		end
	end

	private

		def note_params
	    params.require(:note).permit :name, :description, :schedule_id
	  end

	  def init_entity
	  	@note = Note.find(params[:id])
	  end
end
