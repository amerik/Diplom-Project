# coding: utf-8
module ImageFile

	def self.included(base)
    base.class_eval do
      before_destroy :remove_file

      def file_url(prefix = "")
      	prefix = "_#{prefix}" if prefix != ""
		    if !self.file.file
		      "/assets/#{self.class.name.downcase}#{prefix}.jpg"
		    else
		    	if prefix != ""
		      	self.file.url "size#{prefix}"
		      else
		      	self.file.url
		      end
		    end
		  end
    end
  end

	protected

		def remove_file
			unless self.file.file.nil?
		    dir = self.file.file.file[0, (self.file.file.file.length - self.file.file.original_filename.length)]
		    if File.exists?(dir)
		      FileUtils.rm_rf(dir)
		    end
		  end
	  end
end