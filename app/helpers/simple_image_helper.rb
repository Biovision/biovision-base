# frozen_string_literal: true

# Helper methods for displaying versions for SimpleImageUploader
module SimpleImageHelper
  # @param [ApplicationRecord] entity
  # @param [Hash] options
  def simple_image_preview(entity, options = {})
    return '' if entity.image.blank?

    default = {
      alt: entity.respond_to?(:image_alt_text) ? entity.image_alt_text : ''
    }
    image_tag(entity.image.preview_url, default.merge(options))
  end

  # @param [ApplicationRecord] entity
  # @param [Hash] options
  def simple_image_small(entity, options = {})
    return '' if entity.image.blank?

    default = {
      alt: entity.respond_to?(:image_alt_text) ? entity.image_alt_text : '',
    }
    default[:srcset] = "#{entity.image.medium.url} 2x" if entity.image.raster?

    image_tag(entity.image.small_url, default.merge(options))
  end

  # @param [ApplicationRecord] entity
  # @param [Hash] options
  def simple_image_medium(entity, options = {})
    return '' if entity.image.blank?

    default = {
      alt: entity.respond_to?(:image_alt_text) ? entity.image_alt_text : '',
    }
    default[:srcset] = "#{entity.image.large.url} 2x" if entity.image.raster?

    image_tag(entity.image.medium_url, default.merge(options))
  end

  # @param [ApplicationRecord] entity
  # @param [Hash] options
  def simple_image_large(entity, options = {})
    return '' if entity.image.blank?

    default = {
      alt: entity.respond_to?(:image_alt_text) ? entity.image_alt_text : '',
    }
    default[:srcset] = "#{entity.image.hd.url} 2x" if entity.image.raster?

    image_tag(entity.image.large_url, default.merge(options))
  end

  # @param [ApplicationRecord] entity
  # @param [Hash] options
  def simple_image_hd(entity, options = {})
    return '' if entity.image.blank?

    default = {
      alt: entity.respond_to?(:image_alt_text) ? entity.image_alt_text : ''
    }

    image_tag(entity.image.hd_url, default.merge(options))
  end
end
