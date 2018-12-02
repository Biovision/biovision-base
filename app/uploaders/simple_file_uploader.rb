# frozen_string_literal: true

# Simple file uploader without any processing
class SimpleFileUploader < CarrierWave::Uploader::Base
  storage :file

  def store_dir
    slug = "#{model.id / 100}/#{model.id}"

    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{slug}"
  end
end
