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
    image_tag(entity.image.preview.url, default.merge(options))
  end

  # @param [ApplicationRecord] entity
  # @param [Hash] options
  def simple_image_small(entity, options = {})
    return '' if entity.image.blank?

    default = {
      alt: entity.respond_to?(:image_alt_text) ? entity.image_alt_text : '',
      srcset: "#{entity.image.medium.url} 2x"
    }
    image_tag(entity.image.small.url, default.merge(options))
  end

  # @param [ApplicationRecord] entity
  # @param [Hash] options
  def simple_image_medium(entity, options = {})
    return '' if entity.image.blank?

    default = {
      alt: entity.respond_to?(:image_alt_text) ? entity.image_alt_text : '',
      srcset: "#{entity.image.large.url} 2x"
    }
    image_tag(entity.image.medium.url, default.merge(options))
  end

  # @param [ApplicationRecord] entity
  # @param [Hash] options
  def simple_image_large(entity, options = {})
    return '' if entity.image.blank?

    default = {
      alt: entity.respond_to?(:image_alt_text) ? entity.image_alt_text : '',
      srcset: "#{entity.image.hd.url} 2x"
    }
    image_tag(entity.image.large.url, default.merge(options))
  end

  # @param [ApplicationRecord] entity
  # @param [Hash] options
  def simple_image_hd(entity, options = {})
    return '' if entity.image.blank?

    default = {
      alt: entity.respond_to?(:image_alt_text) ? entity.image_alt_text : ''
    }
    image_tag(entity.image.hd.url, default.merge(options))
  end
end
