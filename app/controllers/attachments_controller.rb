# coding: utf-8
class AttachmentsController < ApplicationController
	inherit_resources

	before_filter :init_entity, only: [:download]

	def download
		send_file @attachment.file.file.file, filename: @attachment.file.file.original_filename
	end

	private

		def init_entity
	  	@attachment = Attachment.find(params[:id])
	  end
end
