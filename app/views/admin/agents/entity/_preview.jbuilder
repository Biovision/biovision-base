json.id entity.id
json.type entity.class.table_name
json.attributes do
  json.(entity, :name)
end
json.links do
  json.self admin_agent_url(entity.id)
end
