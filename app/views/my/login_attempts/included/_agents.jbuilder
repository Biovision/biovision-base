json.(agents) do |agent|
  json.id agent.id
  json.type agent.class.table_name
  json.attributes do
    json.(agent, :name)
  end
end
