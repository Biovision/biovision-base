module MediaHelper
  # @param [MediaFolder] entity
  def admin_media_folder_link(entity)
    link_to(entity.name, admin_media_folder_path(entity.id))
  end

  # @param [MediaFolder|MediaFile] entity
  def media_snapshot_preview(entity)
    versions = "#{entity.snapshot.preview_2x.url} 2x"
    image_tag(entity.snapshot.preview.url, alt: entity.name, srcset: versions)
  end
end
