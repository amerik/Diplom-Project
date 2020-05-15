# coding: utf-8
class MessagesController < ApplicationController
	inherit_resources

	def create
		if @user_current.auth?
			message = Message.new(message_params)
			message.user_sender = @user_current
			if message.save
				unless params[:files].nil?
					params[:files].each do |file|
						if %w(jpg png gif).include?(Attachment.get_type_file(file.original_filename))
							message.message_items << MessageItem.new do |a|
								a.image = file
							end
						else
							message.attachments << Attachment.new do |a|
								a.file = file
							end
						end
					end
				end
				messages_html = render_to_string(partial: 'messages/chat_item', locals: {messages: [message]}, layout: false, formats: [:html], handlers: [:haml])
				render :json => { :status => "success", :messages => messages_html, :message_id => message.id }
			else
				render :json => { :status => "error", :errors => message.errors.messages }
			end
		end
	end

	def update_last
		if @user_current.auth?
			last_id = params[:last_id]
			last_id = 0 if params[:last_id].nil?
			messages = Message.has_chat(params[:chat_id]).where("id > ?", last_id)
			Message.has_chat(params[:chat_id]).has_user(@user_current).each do |message|
			  message.sent_read
		  end

			messages_html = render_to_string(partial: 'messages/chat_item', locals: {messages: messages}, layout: false, formats: [:html], handlers: [:haml])
			render :json => { :status => "success", :messages => messages_html, :count_messages => messages.count }
		end
	end

	def message_count
		count = Message.has_user(@user_current).has_status('not_read').count
		last_message = Message.has_user(@user_current).has_status('not_read').last
		messages_html = render_to_string(partial: 'layouts/messages_count', locals: {:count => count, :last_message => last_message}, layout: false, formats: [:html], handlers: [:haml])
    render :json => { :status => 'success', :messages_html => messages_html }
	end

	private

	  def message_params
	    params.require(:message).permit :description, :chat_id, :user_id
	  end
end
