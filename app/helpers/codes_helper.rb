module CodesHelper
  # @param [Code] entity
  def admin_code_link(entity)
    link_to entity.body, admin_code_path(id: entity.id)
  end

  def code_types_for_select
    CodeType.order('id asc').map { |c| [c.name, c.id] }
  end
end
