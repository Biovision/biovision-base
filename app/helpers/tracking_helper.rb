module TrackingHelper
  # @param [Agent] entity
  def admin_agent_link(entity)
    link_to(entity.name, admin_agent_path(id: entity.id))
  end

  # @param [Browser] entity
  def admin_browser_link(entity)
    link_to(entity.name, admin_browser_path(id: entity.id))
  end

  def browsers_for_select
    options = [[t(:not_set), '']]
    Browser.ordered_by_name.each { |browser| options << [browser.name, browser.id] }
    options
  end
end