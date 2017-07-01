json.data @collection do |entity|
  json.id entity.id
  json.type entity.class.table_name
  json.attributes do
    json.(entity, :created_at, :password, :ip)
  end
  json.relationships do
    json.user do
      json.data do
        json.id entity.user_id
        json.type entity.user.class.table_name
      end
    end
    unless entity.agent.nil?
      json.agent do
        json.data do
          json.id entity.agent_id
          json.type entity.agent.class.table_name
        end
      end
    end
  end
end
json.included do
  json.partial! 'admin/login_attempts/included/users', locals: { collection: User.where(id: @collection.pluck(:user_id).uniq) }
  json.partial! 'admin/login_attempts/included/agents', locals: { collection: Agent.where(id: @collection.pluck(:agent_id).uniq) }
end
json.partial! 'shared/pagination', locals: { collection: @collection }
