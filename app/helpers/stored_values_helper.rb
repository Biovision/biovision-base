module StoredValuesHelper
  # @param [StoredValue] entity
  def admin_stored_value_link(entity)
    link_to entity.slug, admin_stored_value_path(id: entity.id)
  end
end
