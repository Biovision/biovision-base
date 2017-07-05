module BiovisionRegionsHelper
  # @param [Region] entity
  def admin_region_link(entity)
    link_to(entity.name, admin_region_path(entity.id))
  end

  # @param [Region] entity
  def region_image_preview(entity)
    unless entity.image.blank?
      versions = "#{entity.image.preview_2x.url} 2x"
      image_tag(entity.image.preview.url, alt: entity.name, srcset: versions)
    end
  end

  # @param [Region] entity
  def region_image_medium(entity)
    unless entity.image.blank?
      versions = "#{entity.image.medium_2x.url} 2x"
      image_tag(entity.image.medium.url, alt: entity.name, srcset: versions)
    end
  end
end
