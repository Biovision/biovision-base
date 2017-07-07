json.data @collection do |entity|
  json.id entity.id
  json.type entity.class.table_name
  json.attributes do
    json.(entity, :name, :long_slug, :children_cache)
  end
  json.meta do
    json.html_chunk render(partial: 'admin/privileges/entity/region', formats: [:html], locals: { privilege: @entity, region: entity, user: @user })
  end
end
