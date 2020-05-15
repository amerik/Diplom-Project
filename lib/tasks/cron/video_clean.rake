# coding: utf-8

# bundle exec rake cron:video_cleaning
# RAILS_ENV=production bundle exec rake cron:video_cleaning

namespace :cron do
  desc "Initialize all params in tables"
  task :video_cleaning => :environment do

  	# recorded_path = '/home/thamira/Desktop/records' 
  	# encoded_path = '/home/thamira/Desktop/encodes'
  	# final_path = '/home/thamira/projects/eleway/public/videos'

    recorded_path = '/home/panchuk/records' 
    encoded_path = '/home/panchuk/encodes'
    final_path = '/home/panchuk/eleway/public/videos'   

  	video_extenshion = '-video.mjr'
  	audio_extenshion = '-audio.mjr'

    Video.has_status("ready").each do |video|
    	original_video_file = "#{recorded_path}/#{video.file}-video.mjr"
    	original_audio_file = "#{recorded_path}/#{video.file}-audio.mjr"

    	encoded_video_file = "#{encoded_path}/#{video.file}-video.webm"
    	encoded_audio_file = "#{encoded_path}/#{video.file}-audio.opus"

    	final_file = "#{final_path}/#{video.file}.webm"

    	if File.file?(final_file)
				if File.file?(encoded_audio_file)
				  files = [original_video_file, original_audio_file, encoded_video_file, encoded_audio_file]
				  files.each do |file|
				  	File.delete(file) if File.exist?(file)
				  	p "Deleting------#{file}"
				  end				  
    		end
    	end
    end

  end
end


