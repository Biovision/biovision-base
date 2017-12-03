module MediaHelper
  # @param [MediaFolder] entity
  # @param [String] text
  def admin_media_folder_link(entity, text = entity.name)
    link_to(text, admin_media_folder_path(entity.id))
  end

  # @param [MediaFile] entity
  def admin_media_file_link(entity)
    link_to(entity.name, admin_media_file_path(entity.id))
  end

  # @param [MediaFolder|MediaFile] entity
  def media_snapshot_preview(entity)
    versions = "#{entity.snapshot.preview_2x.url} 2x"
    image_tag(entity.snapshot.preview.url, alt: entity.name, srcset: versions)
  end

  # @param [MediaFile] entity
  def media_file_medium(entity)
    return '' if entity.file.blank?

    versions = "#{entity.file.medium_2x.url} 2x"
    image_tag(entity.file.medium.url, alt: entity.description, srcset: versions)
  end
end
