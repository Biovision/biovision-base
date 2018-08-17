module BiovisionUsersHelper
  def genders_for_select
    genders = [[t(:not_selected), '']]
    genders + UserProfileHandler::GENDERS.keys.map { |k| [gender_name(k), k] }
  end

  # @param [Integer] gender_id
  def gender_name(gender_id)
    prefix = 'activerecord.attributes.user_profile.genders.'
    if UserProfileHandler::GENDERS.key?(gender_id)
      t("#{prefix}.#{UserProfileHandler::GENDERS[gender_id]}")
    else
      t(:not_selected)
    end
  end

  # @param [User] entity
  # @param [String] text
  def user_link(entity, text = entity&.profile_name)
    return I18n.t(:anonymous) if entity.nil? || entity.deleted?

    link_to(text, user_profile_path(slug: entity.screen_name), class: 'profile')
  end

  # @param [User] entity
  # @param [String] text
  def admin_user_link(entity, text = entity&.profile_name)
    return I18n.t(:anonymous) if entity.nil?

    link_to(text, admin_user_path(id: entity.id), class: 'profile')
  end

  # @param [ForeignUser] entity
  # @param [String] text
  def admin_foreign_user_link(entity, text = entity.long_slug)
    link_to(text, admin_foreign_user_path(id: entity.id))
  end

  # @param [User] entity
  # @deprecated use #admin_user_link
  def editor_user_link(entity)
    return t(:anonymous) if entity.nil?

    entity.profile_name
  end

  # @param [Token] entity
  def admin_token_link(entity)
    link_to entity.name, admin_token_path(id: entity.id)
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
  def user_image_tiny(entity)
    versions = "#{entity.image.tiny_2x.url} 2x"
    image_tag(entity.image.tiny.url, alt: entity.profile_name, srcset: versions)
  end

  # @param [User] entity
  def user_image_preview(entity)
    versions = "#{entity.image.preview_2x.url} 2x"
    image_tag(entity.image.preview.url, alt: entity.profile_name, srcset: versions)
  end

  # @param [User] entity
  def user_image_profile(entity)
    versions = "#{entity.image.big.url} 2x"
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
