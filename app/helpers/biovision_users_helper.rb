module BiovisionUsersHelper
  def genders_for_select
    genders = [[t(:not_selected), '']]
    prefix  = 'activerecord.attributes.user.genders.'
    genders + User.genders.keys.to_a.map { |o| [I18n.t("#{prefix}#{o}"), o] }
  end

  # @param [User] user
  def user_link(user)
    return I18n.t(:anonymous) if user.nil? || user&.deleted?
    text = user.profile_name
    link_to(text, user_profile_path(slug: user.screen_name), class: 'profile')
  end

  # @param [User] user
  def admin_user_link(user)
    return I18n.t(:anonymous) if user.nil?
    text = user.profile_name
    link_to(text, admin_user_path(user), class: "profile")
  end

  # @param [User] user
  def profile_avatar(user)
    if user.is_a?(User) && !user.image.blank? && !user.deleted?
      image_tag user.image.profile.url
    else
      image_tag 'biovision/base/placeholders/user.svg'
    end
  end
end
