# frozen_string_literal: true

if Rails.env.test? || Rails.env.cucumber?
  Dir["#{Rails.root}/app/uploaders/*.rb"].each(&method(:require))

  CarrierWave.configure do |config|
    config.storage = :file
    config.enable_processing = false
  end

  # use different dirs when testing
  CarrierWave::Uploader::Base.descendants.each do |klass|
    next if klass.anonymous?

    klass.class_eval do
      def cache_dir
        "#{Rails.root}/spec/support/uploads/tmp"
      end

      def store_dir
        slug = "#{model.class.to_s.underscore}/#{mounted_as}"

        "#{Rails.root}/spec/support/uploads/#{slug}/#{model.id}"
      end
    end
  end
end
