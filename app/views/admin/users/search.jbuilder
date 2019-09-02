json.data @collection do |entity|
  json.id entity.id
  json.type entity.class.table_name
  json.attributes do
    json.call(entity, :slug, :email)
  end
  json.meta do
    json.name entity.full_name
  end
end
json.meta do
  json.html render(partial: 'admin/users/search/results', formats: [:html], locals: { collection: @collection })
  json.count t(:user_count, count: @collection.count)
end
