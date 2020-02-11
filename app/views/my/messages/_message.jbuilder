json.id entity.id
json.type entity.class.table_name
json.attributes do
  json.call(entity, :created_at, :body)
end
json.meta do
  json.direction entity.sender?(current_user) ? 'out' : 'in'
  json.html render(partial: 'my/messages/message', formats: [:html], locals: { entity: entity })
end
