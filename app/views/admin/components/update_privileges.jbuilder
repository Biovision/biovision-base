json.data do
  json.id @entity.id
  json.type @entity.class.table_name
  json.attributes do
    json.call(@entity, :user_id, :data)
  end
  json.relationships do
    json.user do
      json.data do
        json.id @entity.user.id
        json.type @entity.user.class.table_name
        json.attributes do
          json.call(@entity.user, :screen_name)
        end
        json.meta do
          json.full_name @entity.user.full_name
        end
      end
    end
  end
end
