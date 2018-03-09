json.meta do
  json.valid @entity.valid?
  json.errors @entity.errors
end
