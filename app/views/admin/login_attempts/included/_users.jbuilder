json.(collection) do |entity|
  json.partial!('admin/users/entity/preview', locals: { entity: entity } )
end
