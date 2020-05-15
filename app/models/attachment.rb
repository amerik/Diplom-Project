# coding: utf-8
class Attachment < ActiveRecord::Base
	attr_accessible :kind

	mount_uploader :file, AttachmentUploader

	extend Enumerize
	enumerize :kind, in: %w(your_cv any_first any_second), predicates: true

	scope :has_kind, -> (kind) { where("kind = ?", kind) }

  # validates :file, file_size: { less_than_or_equal_to: 3.megabytes }
  
  belongs_to :attachable, polymorphic: true
  belongs_to :user
  before_destroy :remove

  # image1.jpg
  def original_filename
    file.file.original_filename
  end

  # /usr/home/me/uploads/attachment/file/1/xxx.jpg
  def path
    file.file.file
  end

  def size
    (file.file.size.to_f / 1000000.to_f).to_f
  end

  # image/jpeg
  def content_type
    file.set_content_type
    file.file.content_type
  end

  # png
  def get_type
    Attachment.get_type_file(self.original_filename)
  end

  # png
  def self.get_type_file(file)
    name_type = file

    1.upto(10) do |i|
      unless name_type.index(".").nil?
        name_type = name_type[name_type.index(".") + 1, name_type.length - name_type.index(".")]
      else
          break
      end
    end

    name_type.mb_chars.downcase.to_s
  end

  # беруться все версии файлов из каталога
  def get_files
    Dir.glob(File.dirname(path)+"/*").map do |f| File.basename f end
  end

  def set_by_attachable(file, attachable, user)
    self.file = file
    self.attachable = attachable
    self.user = user
    self.save
  end

  def arhive?(file)
    %w(rar zip).include?(Attachment.get_type_file(file))
  end

  def photo?(file)
    %w(jpg png gif).include?(Attachment.get_type_file(file))
  end

  def get_resource(file)
    File.dirname(self.file.url) + "/" + file
  end

  private

    def remove
      dir = self.path[0, (self.path.length - self.original_filename.length)]
      if File.exists?(dir)
        FileUtils.rm_rf(dir)
      end
    end
end
