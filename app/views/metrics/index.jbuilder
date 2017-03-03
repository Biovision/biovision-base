json.data @collection do |entity|
  json.type entity.class.table_name
  ison.id entity.id
  json.attributes do
    json.(entity, :name, :description, :value, :previous_value, :incremental, :start_with_zero, :default_period)
  end
end
