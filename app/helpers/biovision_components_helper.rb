# frozen_string_literal: true

# Helper methods for component handling
module BiovisionComponentsHelper
  # @param [BiovisionComponent] entity
  # @param [String] text
  # @param [Hash] options
  def admin_biovision_component_link(entity, text = entity.slug, options = {})
    link_to(text, admin_component_path(slug: entity.slug), options)
  end
end
