class MediaFileUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  include CarrierWave::BombShelter

  # Choose what kind of storage to use for this uploader:
  storage :file
  # storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id/10000.floor}/#{model.id/100.floor}/#{model.id}"
  end

  version :medium_2x do
    resize_to_fit 1280, 1280
  end

  version :medium, from_version: :medium_2x do
    resize_to_fit 640, 640
  end

  def extension_whitelist
    %w(jpg jpeg gif png)
  end

  def filename
    "#{model.uuid}.#{file.extension}" if original_filename
  end
end
