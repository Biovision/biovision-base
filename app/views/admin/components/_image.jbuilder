json.data do
  json.id entity.id
  json.type entity.class.table_name
  json.attributes do
    json.call(entity, :caption, :image_alt_text, :source_name, :source_link)
  end
  json.meta do
    json.url do
      json.medium entity.image.medium_url
    end
  end
end
