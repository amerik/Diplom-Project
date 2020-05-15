# coding: utf-8
module Image

	def self.included(base)
    base.class_eval do
      before_destroy :remove

      def image_url(prefix = "", format = 'jpg')
      	prefix = "_#{prefix}" if prefix != ""
		    if !self.image.file
		      "/assets/#{self.class.name.downcase}#{prefix}.#{format}"
		    else
		    	if prefix != ""
		      	self.image.url "size#{prefix}"
		      else
		      	self.image.url
		      end
		    end
		  end
    end
  end

	protected

		def remove
			unless self.image.file.nil?
		    dir = self.image.file.file[0, (self.image.file.file.length - self.image.file.original_filename.length)]
		    if File.exists?(dir)
		      FileUtils.rm_rf(dir)
		    end
		  end
	  end
end