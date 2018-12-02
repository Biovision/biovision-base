module BiovisionHelper
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

  # @param [String] path
  # @param [String] title
  # @param [Hash] options
  def world_icon(path, title = t(:view_as_visitor), options = {})
    icon_with_link('biovision/base/icons/world.svg', path, title, options)
  end

  # @param [String] path
  # @param [String] title
  # @param [Hash] options
  def gear_icon(path, title = t(:view_as_administrator), options = {})
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
      data:   { confirm: t(:are_you_sure), tootik: title, tootik_conf: 'danger' }
    }
    icon_with_link('biovision/base/icons/destroy.svg', entity, title, default.merge(options))
  end

  # @param [String] path
  # @param [String] title
  # @param [Hash] options
  def destroy_path_icon(path, title = t(:delete), options = {})
    default = {
      method: :delete,
      data:   { confirm: t(:are_you_sure), tootik: title, tootik_conf: 'danger' }
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


  # @param [SimpleImageUploader] uploader
  # @param [String] alt_text
  def simple_image_preview(uploader, alt_text = '')
    return '' if uploader.blank?

    image_tag(uploader.preview.url, alt: alt_text)
  end

  # @param [SimpleImageUploader] uploader
  # @param [String] alt_text
  def simple_image_small(uploader, alt_text = '')
    return '' if uploader.blank?

    versions = "#{uploader.medium.url} 2x"
    image_tag(uploader.small.url, alt: alt_text, srcset: versions)
  end

  # @param [SimpleImageUploader] uploader
  # @param [String] alt_text
  def simple_image_medium(uploader, alt_text = '')
    return '' if uploader.blank?

    versions = "#{uploader.large.url} 2x"
    image_tag(uploader.medium.url, alt: alt_text, srcset: versions)
  end

  # @param [SimpleImageUploader] uploader
  # @param [String] alt_text
  def simple_image_large(uploader, alt_text = '')
    return '' if uploader.blank?

    versions = "#{uploader.hd.url} 2x"
    image_tag(uploader.large.url, alt: alt_text, srcset: versions)
  end

  # @param [SimpleImageUploader] uploader
  # @param [String] alt_text
  def simple_image_hd(uploader, alt_text = '')
    return '' if uploader.blank?

    image_tag(uploader.hd.url, alt: alt_text)
  end
end
