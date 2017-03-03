class AvatarUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  include CarrierWave::BombShelter

  def max_pixel_dimensions
    [4000, 4000]
  end

  storage :file

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id/10000.floor}/#{model.id/100.floor}/#{model.id}"
  end

  def default_url
    ActionController::Base.helpers.asset_path('biovision/base/placeholders/user.svg')
  end

  process :auto_orient

  def auto_orient
    manipulate! do |image|
      image.tap(&:auto_orient)
    end
  end

  version :big_2x do
    resize_to_fit(1280, 1280)
  end

  version :big, from_version: :big_2x do
    resize_to_fit(640, 640)
  end

  version :profile_2x, from_version: :big do
    resize_to_fit(640, 640)
  end

  version :profile, from_version: :profile_2x do
    resize_to_fit(320, 320)
  end

  version :preview_2x, from_version: :profile do
    resize_to_fit(160, 160)
  end

  version :preview, from_version: :preview_2x do
    resize_to_fit(80, 80)
  end

  version :tiny_2x, from_version: :preview do
    resize_to_fit(48, 48)
  end

  version :tiny, from_version: :tiny_2x do
    resize_to_fit(24, 24)
  end

  def extension_white_list
    %w(jpg jpeg png)
  end
end
