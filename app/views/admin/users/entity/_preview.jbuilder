json.id entity.id
json.type entity.class.table_name
json.attributes do
  json.(entity, :screen_name)
end
json.meta do
  json.image_2x_url entity.image.preview_2x.url
  json.image_url entity.image.preview.url
end
json.links do
  json.self admin_user_url(entity.id)
end
