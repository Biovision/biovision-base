module BiovisionUsersHelper
  def genders_for_select
    genders = [[t(:not_selected), '']]
    prefix  = 'activerecord.attributes.user.genders.'
    genders + User.genders.keys.to_a.map { |o| [I18n.t("#{prefix}#{o}"), o] }
  end

  # @param [User] entity
  def user_link(entity)
    return I18n.t(:anonymous) if entity.nil? || entity.deleted?

    text = entity.profile_name
    link_to(text, user_profile_path(slug: entity.screen_name), class: 'profile')
  end

  # @param [User] entity
  def admin_user_link(entity)
    return I18n.t(:anonymous) if entity.nil?

    text = entity.profile_name
    link_to(text, admin_user_path(entity.id), class: 'profile')
  end

  # @param [User] user
  def profile_avatar(user)
    if user.is_a?(User) && !user.image.blank? && !user.deleted?
      image_tag user.image.profile.url
    else
      image_tag 'biovision/base/placeholders/user.svg'
    end
  end

  # @param [User] entity
  def user_image_preview(entity)
    return image_tag('biovision/base/placeholders/user.svg') if entity.image.blank?

    versions = "#{entity.image.preview_2x.url} 2x"
    image_tag(entity.image.preview.url, alt: entity.name, srcset: versions)
  end

  # @param [ForeignSite] foreign_site
  def foreign_login_link(foreign_site)
    image = "biovision/base/icons/foreign/#{foreign_site.slug}.svg"
    path  = "/auth/#{foreign_site.slug}"
    link_to(image_tag(image, alt: foreign_site.name), path)
  end
end
