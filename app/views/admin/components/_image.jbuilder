json.data do
  json.id entity.id
  json.type entity.class.table_name
  json.attributes do
    json.call(entity, :uuid, :caption, :image_alt_text, :source_name, :source_link, :object_count)
  end
  json.meta do
    json.name entity.name
    json.size number_to_human_size(entity.file_size)
    json.object_count t(:object_count, count: entity.object_count)
    json.url do
      json.preview entity.image.preview_url
      json.medium entity.image.medium_url
      json.hd entity.image.hd_url
    end
  end
end
