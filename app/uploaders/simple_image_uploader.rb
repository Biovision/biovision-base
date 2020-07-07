# frozen_string_literal: true

# Simple image uploader with scaling
class SimpleImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :file

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    id = model&.id.to_i
    slug = model.respond_to?(:image_slug) ? model.image_slug : "#{id / 1000}/#{id}"

    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{slug}"
  end

  def default_url(*)
    ActionController::Base.helpers.asset_path('biovision/base/placeholders/1x1.svg')
  end

  version :hd, if: :raster_image? do
    resize_to_fit(1920, 1920)
  end

  version :large, from_version: :hd, if: :raster_image? do
    resize_to_fit(1280, 1280)
  end

  version :medium, from_version: :large, if: :raster_image? do
    resize_to_fit(640, 640)
  end

  version :small, from_version: :medium, if: :raster_image? do
    resize_to_fit(320, 320)
  end

  version :preview, from_version: :small, if: :raster_image? do
    resize_to_fit(160, 160)
  end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_whitelist
    %w[jpg jpeg png svg svgz]
  end

  # Text for image alt attribute
  #
  # @param [String] default
  # @return [String]
  def alt_text(default = '')
    method_name = "#{mounted_as}_alt_text".to_sym
    if model.respond_to?(method_name)
      model.send(method_name)
    else
      default
    end
  end

  # @param [SanitizedFile]
  def raster_image?(new_file)
    !new_file.extension.match?(/svgz?\z/i)
  end

  def raster?
    !File.extname(path).match?(/\.svgz?\z/i)
  end

  def preview_url
    raster? ? preview.url : url
  end

  def small_url
    raster? ? small.url : url
  end

  def medium_url
    raster? ? medium.url : url
  end

  def large_url
    raster? ? large.url : url
  end

  def hd_url
    raster? ? hd.url : url
  end
end
