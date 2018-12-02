# frozen_string_literal: true

# Simple image uploader with scaling
class SimpleImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :file

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    slug = "#{model.id / 1000}/#{model.id}"

    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{slug}"
  end

  version :hd do
    resize_to_fit(1920, 1920)
  end

  version :large, from_version: :hd do
    resize_to_fit(1280, 1280)
  end

  version :medium, from_version: :large do
    resize_to_fit(640, 640)
  end

  version :small, from_version: :medium do
    resize_to_fit(320, 320)
  end

  version :preview, from_version: :small do
    resize_to_fit(160, 160)
  end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_whitelist
    %w[jpg jpeg png]
  end
end
