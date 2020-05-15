# coding: utf-8
class PartnerUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :file

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  version :size_220x66 do
    process :resize_to_limit => [220, 66]
  end


  def extension_white_list
    %w(jpg jpeg png gif)
  end
end
