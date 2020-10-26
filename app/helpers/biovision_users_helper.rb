# frozen_string_literal: true

# Helper methods for user handling
module BiovisionUsersHelper
  def genders_for_select
    genders = [[t(:not_selected), '']]
    genders + UserProfileHandler::GENDERS.keys.map { |k| [gender_name(k), k] }
  end

  # @param [Integer] gender_id
  def gender_name(gender_id)
    prefix = 'activerecord.attributes.user_profile.genders'
    gender_key = gender_id.blank? ? '' : gender_id.to_i
    if UserProfileHandler::GENDERS.key?(gender_key)
      t("#{prefix}.#{UserProfileHandler::GENDERS[gender_key]}")
    else
      t(:not_selected)
    end
  end

  # @param [User] entity
  # @param [String] text
  # @param [Hash] options
  def user_link(entity, text = entity&.profile_name, options = {})
    return I18n.t(:anonymous) if entity.nil? || entity.deleted?

    link_options = { class: 'profile' }.merge(options)
    link_to(text, user_profile_path(slug: entity.slug), link_options)
  end

  # @param [User] entity
  # @param [String] text
  # @param [Hash] options
  # @deprecated use #admin_entity_link
  def admin_user_link(entity, text = entity&.profile_name, options = {})
    return I18n.t(:anonymous) if entity.nil?

    link_options = { class: 'profile' }.merge(options)
    link_to(text, admin_user_path(id: entity.id), link_options)
  end

  # @param [User] entity
  # @deprecated use #admin_entity_link
  def editor_user_link(entity)
    return t(:anonymous) if entity.nil?

    entity.profile_name
  end

  # @param [User] entity
  def profile_avatar(entity)
    if entity&.image.blank? || entity.deleted?
      image_tag('biovision/base/placeholders/user.svg', alt: '')
    else
      user_image_profile(entity)
    end
  end

  # @param [User] entity
  # @param [Hash] options
  def user_image_tiny(entity, options = {})
    if entity&.image.blank? || entity.deleted?
      image_tag('biovision/base/placeholders/user.svg', alt: '')
    else
      default_options = {
        alt: entity.profile_name,
        srcset: "#{entity.image.tiny_2x.url} 2x"
      }
      image_tag(entity.image.tiny.url, default_options.merge(options))
    end
  end

  # @param [User] entity
  # @param [Hash] options
  def user_image_preview(entity, options = {})
    if entity&.image.blank? || entity.deleted?
      image_tag('biovision/base/placeholders/user.svg', alt: '')
    else
      default_options = {
        alt: entity.profile_name,
        srcset: "#{entity.image.preview_2x.url} 2x"
      }
      image_tag(entity.image.preview.url, default_options.merge(options))
    end
  end

  # @param [User] entity
  # @param [Hash] options
  def user_image_profile(entity, options = {})
    if entity&.image.blank? || entity.deleted?
      image_tag('biovision/base/placeholders/user.svg', alt: '')
    else
      default_options = {
        alt: entity.profile_name,
        srcset: "#{entity.image.big.url} 2x"
      }
      image_tag(entity.image.profile.url, default_options.merge(options))
    end
  end

  # @param [User] entity
  # @param [Hash] options
  def user_image_big(entity, options = {})
    if entity&.image.blank? || entity.deleted?
      image_tag('biovision/base/placeholders/user.svg', alt: '')
    else
      default_options = {
        alt: entity.profile_name,
        srcset: "#{entity.image.big_2x.url} 2x"
      }
      image_tag(entity.image.big.url, default_options.merge(options))
    end
  end

  # @param [ForeignSite] foreign_site
  def foreign_login_link(foreign_site)
    image = "biovision/base/icons/foreign/#{foreign_site.slug}.svg"
    path = "/auth/#{foreign_site.slug}"
    link_to(image_tag(image, alt: foreign_site.name), path)
  end
end
