# coding: utf-8
class MessageItemUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :file

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end
  
  version :size_130x130 do
    process :resize_to_fill => [130, 130]
  end

  def extension_white_list
    %w(jpg jpeg png gif)
  end
end
