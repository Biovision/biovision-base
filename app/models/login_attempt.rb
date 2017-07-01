class LoginAttempt < ApplicationRecord
  include HasOwner

  PER_PAGE = 20

  belongs_to :user
  belongs_to :agent, optional: true

  before_validation { self.password = password.to_s[0..254] }

  scope :recent, -> { order('id desc') }
  scope :since, ->(time) { where('created_at > ?', time)}

  # @param [Integer] page
  def self.page_for_administration(page = 1)
    recent.page(page).per(PER_PAGE)
  end

  # @param [User] user
  # @param [Integer] page
  def self.page_for_owner(user, page = 1)
    owned_by(user).recent.page(page).per(PER_PAGE)
  end
end
