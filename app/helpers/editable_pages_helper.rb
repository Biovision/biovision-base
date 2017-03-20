module EditablePagesHelper
  # @param [EditablePage] entity
  def admin_editable_page_link(entity)
    link_to(entity.name, admin_editable_page_path(entity.id))
  end

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
end
