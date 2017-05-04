json.data do
  json.start_with_zero @entity.start_with_zero?
  json.name @entity.name
  json.description @entity.description
  json.graph_data @entity.graph_data
end
