class MediaSnapshotUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  include CarrierWave::BombShelter

  # Choose what kind of storage to use for this uploader:
  storage :file
  # storage :fog

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id/10000.floor}/#{model.id/100.floor}/#{model.id}"
  end

  def default_url(*args)
    ActionController::Base.helpers.asset_path('biovision/base/placeholders/file.svg')
  end

  version :preview_2x do
    resize_to_fit(160, 160)
  end

  version :preview, from_version: :preview_2x do
    resize_to_fit(80, 80)
  end

  def extension_whitelist
    %w(jpg jpeg png)
  end

  def filename
    "#{model.uuid}.#{file.extension}" if original_filename
  end
end
