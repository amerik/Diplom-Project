# coding: utf-8

# bundle exec rake cron:check_end_schedule

namespace :cron do
  desc "Initialize all params in tables"
  task :check_end_schedule => :environment do

  	Schedule.has_status('in_work').each do |schedule|
      if DateTime.now > (schedule.start_at + 1.hours)
        schedule.sent_success
      end
    end

  end
end


