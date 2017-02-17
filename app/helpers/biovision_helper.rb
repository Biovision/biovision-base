module BiovisionHelper
  # @param [String] path
  # @param [String] title
  # @param [Hash] options
  def create_icon(path, title = t(:create), options = {})
    icon_with_link('biovision/base/icons/create.svg', path, title, options)
  end

  # @param [String] path
  # @param [String] title
  # @param [Hash] options
  def back_icon(path, title = t(:back), options = {})
    icon_with_link('biovision/base/icons/back.svg', path, title, options)
  end

  # @param [String] path
  # @param [String] title
  # @param [Hash] options
  def return_icon(path, title = t(:back), options = {})
    icon_with_link('biovision/base/icons/return.svg', path, title, options)
  end

  # @param [String] path
  # @param [String] title
  # @param [Hash] options
  def edit_icon(path, title = t(:edit), options = {})
    icon_with_link('biovision/base/icons/edit.svg', path, title, options)
  end

  # @param [ApplicationRecord] entity
  # @param [String] title
  # @param [Hash] options
  def destroy_icon(entity, title = t(:delete), options = {})
    default = {
        method: :delete,
        data: { confirm: t(:are_you_sure), tootik: title, tootik_conf: 'danger' }
    }
    icon_with_link('biovision/base/icons/destroy.svg', entity, default.merge(options))
  end

  # @param [String] path
  # @param [String] title
  # @param [Hash] options
  def icon_with_link(source, path, title, options = {})
    default = { data: { tootik: title } }
    link_to(image_tag(source, alt: title), path, default.merge(options))
  end

  # @param [ApplicationRecord] entity
  # @param [String] path
  def lock_icons(entity, path)
    render partial: 'shared/actions/locks', locals: { path: path, entity: entity }
  end
end
