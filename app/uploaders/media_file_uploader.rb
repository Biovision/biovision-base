# frozen_string_literal: true

class MediaFileUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  include CarrierWave::BombShelter

  # Choose what kind of storage to use for this uploader:
  storage :file
  # storage :fog

  def store_dir
    slug = "#{model.id / 10_000}/#{model.id / 100}/#{model.id}"

    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{slug}"
  end

  version :medium_2x do
    resize_to_fit 1280, 1280
  end

  version :medium, from_version: :medium_2x do
    resize_to_fit 640, 640
  end

  def extension_whitelist
    %w[jpg jpeg gif png]
  end

  def filename
    "#{model.uuid}.#{file.extension}" if original_filename
  end
end
