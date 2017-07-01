json.data @collection do |entity|
  json.id entity.id
  json.type entity.class.table_name
  json.attributes do
    json.(entity, :created_at, :password)
    json.ip entity.ip.to_s
  end
  unless entity.agent.nil?
    json.relationships do
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
  json.partial! 'my/login_attempts/included/agents', locals: { agents: Agent.where(id: @collection.pluck(:agent_id).uniq) }
end
json.partial! 'shared/pagination', locals: { collection: @collection }
