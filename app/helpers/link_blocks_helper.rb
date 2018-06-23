module LinkBlocksHelper
  # @param [LinkBlock] entity
  def admin_link_block_link(entity)
    text = entity.title.blank? ? entity.slug : entity.title
    link_to(text, admin_link_block_path(id: entity.id))
  end

  # @param [LinkBlockItem] entity
  def admin_link_block_item_link(entity)
    link_to(entity.title, admin_link_block_item_path(id: entity.id))
  end

  # @param [LinkBlock] entity
  def link_block_image(entity)
    return '' if entity.image.blank?
    image_tag(entity.image.url, alt: entity.image_alt_text)
  end
end
