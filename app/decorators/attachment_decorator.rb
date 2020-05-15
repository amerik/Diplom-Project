# coding: utf-8
class AttachmentDecorator < ApplicationDecorator
	decorates_association :attachment
  delegate_all

  def size
  	size_file(object.size)
  end
end
