# coding: utf-8
set :whenever_command, "bundle exec whenever"
require "whenever"
set :environment, :production
set :output, "/home/panchuk/var/log/cron.log"

job_type :command, ":task :output"
job_type :rake,    "cd :path && :environment_variable=:environment bundle exec rake :task --silent :output"
job_type :runner,  "cd :path && rails r ':task' :output"
job_type :script,  "cd :path && :environment_variable=:environment bundle exec script/:task :output"

every 3.minutes do
  rake "cron:check_end_schedule"
end

every 5.minutes do
  rake "cron:video_cleaning"
  rake "cron:video_convert"
end