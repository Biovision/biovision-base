json.data @collection do |entity|
  json.id entity.id
  json.type entity.class.table_name
  json.attributes do
    json.(entity, :created_at, :password, :ip)
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
    json.included do
      json.id entity.agent.id
      json.type entity.agent.class.table_name
      json.attributes do
        json.(entity.agent, :name)
      end
    end
  end
end
json.partial! 'shared/pagination', locals: { collection: @collection }
