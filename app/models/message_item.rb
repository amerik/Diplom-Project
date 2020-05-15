# coding: utf-8
class MessageItem < ActiveRecord::Base
	belongs_to :message

	include Image # 130x130
  mount_uploader :image, MessageItemUploader
end
