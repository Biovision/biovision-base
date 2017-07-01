json.(collection) do |entity|
  json.partial!('admin/agents/entity/preview', locals: { entity: entity } )
end
