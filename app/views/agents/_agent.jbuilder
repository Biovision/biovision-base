json.agent do
  json.(agent, :id, :name, :deleted)
  json.flags do
    json.bot do
      json.name t('activerecord.attributes.agent.bot')
      json.value agent.bot
    end
    json.mobile do
      json.name t('activerecord.attributes.agent.mobile')
      json.value agent.mobile
    end
    json.active do
      json.name t('activerecord.attributes.agent.active')
      json.value agent.active
    end
  end
  json.url api_agent_path(agent)
  json.browser agent.browser.nil? ? nil : agent.browser.name
  json.html render(partial: 'admin/agents/entity/in_list', locals: { agent: agent }, formats: [:html] )
end
