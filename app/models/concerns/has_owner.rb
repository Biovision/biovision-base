module HasOwner
  extend ActiveSupport::Concern

  included do
    scope :owned_by, -> (user) { where(user: user) }
  end

  # @param [User] user
  # @return [Boolean]
  def owned_by?(user)
    user.is_a?(User) && (self.user == user)
  end

  # @return [String]
  def owner_name
    user.is_a?(User) ? user.profile_name : I18n.t(:anonymous)
  end
end
