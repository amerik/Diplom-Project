# coding: utf-8
class ReviewUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick  
  
  storage :file

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  version :size_42x42 do
    process :resize_to_fill => [42, 42]
  end

  version :size_165x165 do
    process :resize_to_fill => [165, 165]
  end

  def extension_white_list
    %w(jpg jpeg png gif)
  end
end
