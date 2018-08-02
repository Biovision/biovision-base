json.data do
  json.id @entity.id
  json.type @entity.class.table_name
  json.attributes do
    json.(@entity, :name)
  end
  json.meta do
    json.file do
      json.large @entity.file.medium_2x.url
      json.medium @entity.file.medium.url
    end
  end
end
