# coding: utf-8

# bundle exec rake tables:test
# RAILS_ENV=production bundle exec rake tables:test

namespace :tables do
  desc "Initialize all params in tables"
  task :test => :environment do
  	# table_name = 'cities'
  	# rows = 19000
  	# ActiveRecord::Base.connection.execute("ALTER SEQUENCE #{table_name}_id_seq RESTART WITH #{rows}")

  	# User.has_role('client').each do |user|
  	# 	1.upto(20) do |index|
  	# 		user.notifications << Notification.new(:kind => 'new_session', :role => 'client', :name => "Free", :description => "You have subscribed to «Free». You can randomly search for a mentor to start classes on the service #{index}")
  	# 	end
  	# end

    Video.order("id asc").last.update_attribute(:status, 'new')
	end
end