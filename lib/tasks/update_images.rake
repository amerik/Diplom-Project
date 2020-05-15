# coding: utf-8

# bundle exec rake pit:update_images

namespace :pit do
  desc "Create all home order"
  task :update_images => :environment do

    PropertyImage.find_each do |page|
      page.image.recreate_versions! if page.image?
    end

  end
end