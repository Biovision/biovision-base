# frozen_string_literal: true

# Helper methods for common situations
module BiovisionHelper
  # @param [ApplicationRecord] entity
  # @param [String] text
  # @param [Hash] options
  def admin_entity_link(entity, text = nil, options = {})
    return '∅' if entity.nil?

    if text.nil?
      text = entity.respond_to?(:text_for_link) ? entity.text_for_link : entity.id
    end

    href = "/admin/#{entity.class.table_name}/#{entity.id}"
    link_to(text, href, options)
  end

  # @param [ApplicationRecord] entity
  # @param [String] text
  # @param [Hash] options
  def entity_link(entity, text = nil, options = {})
    return '' if entity.nil?

    if text.nil?
      text = entity.respond_to?(:text_for_link) ? entity.text_for_link : entity.id
    end

    href = if entity.respond_to?(:world_url)
             entity.world_url
           else
             "/#{entity.class.table_name}/#{entity.id}"
           end

    link_to(text, href, options)
  end

  # @param [Integer] year
  # @param [Integer] month
  def title_for_archive(year, month)
    if year && month
      month_name = t('date.nominative_months')[month.to_i]
      t(:archive_month, year: year.to_i, month: month_name)
    elsif year
      t(:archive_year, year: year.to_i)
    else
      ''
    end
  end

  # @param [String|ApplicationRecord] path
  # @param [String] title
  # @param [Hash] options
  def world_icon(path, title = t(:view_as_visitor), options = {})
    if path.is_a? ApplicationRecord
      table_name = path.class.table_name
      path = path.respond_to?(:world_url) ? path.world_url : "/#{table_name}/#{path.id}"
    end
    icon_with_link('biovision/base/icons/world.svg', path, title, options)
  end

  # @param [String|ApplicationRecord] path
  # @param [String] title
  # @param [Hash] options
  def gear_icon(path, title = t(:view_as_administrator), options = {})
    path = "/admin/#{path.class.table_name}/#{path.id}" if path.is_a? ApplicationRecord
    icon_with_link('biovision/base/icons/gear.svg', path, title, options)
  end

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

  # @param [String|ApplicationRecord] path
  # @param [String] title
  # @param [Hash] options
  def edit_icon(path, title = t(:edit), options = {})
    path = "/admin/#{path.class.table_name}/#{path.id}/edit" if path.is_a? ApplicationRecord
    icon_with_link('biovision/base/icons/edit.svg', path, title, options)
  end

  # @param [String|ApplicationRecord] path
  # @param [String] title
  # @param [Hash] options
  def destroy_icon(path, title = t(:delete), options = {})
    path = "/admin/#{path.class.table_name}/#{path.id}" if path.is_a? ApplicationRecord
    default = {
      class: 'danger',
      method: :delete,
      data: { confirm: t(:are_you_sure), tootik: title, tootik_conf: 'danger' }
    }
    icon_with_link('biovision/base/icons/destroy.svg', path, title, default.merge(options))
  end

  # @param [String|ApplicationRecord] path
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
