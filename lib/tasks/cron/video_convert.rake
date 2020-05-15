# coding: utf-8

# bundle exec rake cron:video_convert
# RAILS_ENV=production bundle exec  rake cron:video_convert

namespace :cron do
  desc "Initialize all params in tables"
  task :video_convert => :environment do

  	# recorded_path = '/home/thamira/Desktop/records' 
  	# encoded_path = '/home/thamira/Desktop/encodes'
  	# final_path = '/home/thamira/projects/eleway/public/videos'
  	# path_janus_pp_rec = '/home/thamira/janus-gateway-master/janus-pp-rec'

    recorded_path = '/home/panchuk/records' 
    encoded_path = '/home/panchuk/encodes'
    final_path = '/home/panchuk/eleway/public/videos'
    path_janus_pp_rec = '/home/panchuk/janus-gateway/janus-pp-rec'

  	video_extenshion = '-video.mjr'
  	audio_extenshion = '-audio.mjr'

    Video.has_status("new").each do |video|
    	original_video_file = "#{recorded_path}/#{video.file}-video.mjr"
    	original_audio_file = "#{recorded_path}/#{video.file}-audio.mjr"

    	encoded_video_file = "#{encoded_path}/#{video.file}-video.webm"
    	encoded_audio_file = "#{encoded_path}/#{video.file}-audio.opus"

    	final_file = "#{final_path}/#{video.file}.webm"

    	if File.file?(original_audio_file) && File.file?(original_video_file) 
    		video.sent_reading
    		p "Encoding-------"
				puts `#{"#{path_janus_pp_rec} #{original_video_file} #{encoded_video_file}"}`
				puts `#{"#{path_janus_pp_rec} #{original_audio_file} #{encoded_audio_file}"}` 
				p "Encoding - ends"

				if File.file?(encoded_audio_file) && File.file?(encoded_video_file) 
				  p "Combining------"
				  puts `#{"ffmpeg -i #{encoded_audio_file} -i #{encoded_video_file}  -c:v copy -c:a opus -strict experimental #{final_file}"}`
				  p "Combining-ends"
				  video.sent_ready		  
    		else
    			video.sent_error
    		end
    	else
    		video.sent_error
    	end
    end

  end
end


