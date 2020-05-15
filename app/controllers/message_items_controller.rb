# coding: utf-8
class MessageItemsController < ApplicationController
	inherit_resources

	before_filter :init_entity, only: [:download]

	def download
		send_file @message_item.image.file.file, filename: @message_item.image.file.original_filename
	end

	private

		def init_entity
	  	@message_item = MessageItem.find(params[:id])
	  end
end
