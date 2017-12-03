module BiovisionUsersHelper
  def genders_for_select
    genders = [[t(:not_selected), '']]
    prefix  = 'activerecord.attributes.user_profile.genders.'
    genders + UserProfile.genders.keys.to_a.map { |o| [t("#{prefix}#{o}"), o] }
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

  # @param [User] entity
  def editor_user_link(entity)
    return t(:anonymous) if entity.nil?

    entity.profile_name
  end

  # @param [Token] entity
  def admin_token_link(entity)
    link_to entity.name, admin_token_path(entity.id)
  end

  # @param [User] entity
  def profile_avatar(entity)
    if entity.is_a?(User) && !entity.image.blank? && !entity.deleted?
      user_image_profile(entity)
    else
      image_tag('biovision/base/placeholders/user.svg')
    end
  end

  # @param [User] entity
  def user_image_preview(entity)
    versions = "#{entity.image.preview_2x.url} 2x"
    image_tag(entity.image.preview.url, alt: entity.profile_name, srcset: versions)
  end

  # @param [User] entity
  def user_image_profile(entity)
    versions = "#{entity.image.profile_2x.url} 2x"
    image_tag(entity.image.profile.url, alt: entity.profile_name, srcset: versions)
  end

  # @param [User] entity
  def user_image_big(entity)
    versions = "#{entity.image.big_2x.url} 2x"
    image_tag(entity.image.big.url, alt: entity.profile_name, srcset: versions)
  end

  # @param [ForeignSite] foreign_site
  def foreign_login_link(foreign_site)
    image = "biovision/base/icons/foreign/#{foreign_site.slug}.svg"
    path  = "/auth/#{foreign_site.slug}"
    link_to(image_tag(image, alt: foreign_site.name), path)
  end
end
