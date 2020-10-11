# frozen_string_literal: true

# Helper methods for handling editable pages and blocks
module EditablePagesHelper
  # @param [EditablePage] entity
  def editable_page_image_preview(entity)
    return '' if entity.image.blank?

    versions = "#{entity.image.preview_2x.url} 2x"
    image_tag(entity.image.preview.url, alt: entity.name, srcset: versions)
  end

  # @param [EditablePage] entity
  def editable_page_image_medium(entity)
    return '' if entity.image.blank?

    versions = "#{entity.image.medium_2x.url} 2x"
    image_tag(entity.image.medium.url, alt: entity.name, srcset: versions)
  end

  # @param [EditablePage] entity
  def editable_page_image_hd(entity)
    return '' if entity.image.blank?

    versions = "#{entity.image.large.url} 2x"
    image_tag(entity.image.medium_2x.url, alt: entity.name, srcset: versions)
  end

  # @param [EditableBlock] entity
  def editable_block_image_preview(entity)
    return '' if entity.image.blank?

    versions = "#{entity.image.preview_2x.url} 2x"
    image_tag(entity.image.preview.url, alt: entity.name, srcset: versions)
  end

  # @param [EditableBlock] entity
  def editable_block_image_medium(entity)
    return '' if entity.image.blank?

    versions = "#{entity.image.medium_2x.url} 2x"
    image_tag(entity.image.medium.url, alt: entity.name, srcset: versions)
  end
end
