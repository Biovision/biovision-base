module HasOwner
  extend ActiveSupport::Concern

  included do
    scope :owned_by, ->(user) { where(user: user) }
    scope :with_user_id, ->(user_id) { where(user_id: user_id) unless user_id.blank? }
  end

  # @param [User] user
  # @return [Boolean]
  def owned_by?(user)
    !user.nil? && (self.user == user)
  end

  # @return [String]
  def owner_name
    user&.profile_name || I18n.t(:anonymous)
  end
end
