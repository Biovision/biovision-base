# @deprecated Do not use
class MediaFile < ApplicationRecord
  include HasOwner

  PER_PAGE = 20

  NAME_LIMIT        = 250
  DESCRIPTION_LIMIT = 250

  mount_uploader :file, MediaFileUploader
  mount_uploader :snapshot, MediaSnapshotUploader

  belongs_to :media_folder, optional: true, counter_cache: true
  belongs_to :user, optional: true
  belongs_to :agent, optional: true

  after_initialize { self.uuid = SecureRandom.uuid if uuid.nil? }

  before_validation { self.mime_type = mime_type.to_s[0..254] }
  before_validation { self.original_name = original_name.to_s[0..254] }

  validates_presence_of :name
  validates_presence_of :file
  validates_length_of :name, maximum: NAME_LIMIT
  validates_length_of :description, maximum: DESCRIPTION_LIMIT
  validates_uniqueness_of :uuid

  scope :ordered_by_name, -> { order('name asc') }
  scope :recent, -> { order('id desc') }

  # @param [Integer] page
  def self.page_for_administration(page = 1)
    ordered_by_name.page(page).per(PER_PAGE)
  end

  def self.entity_parameters
    %i(name description media_folder_id)
  end

  def self.creation_parameters
    entity_parameters + %i(file snapshot mime_type original_name)
  end

  # @param [User] user
  def editable_by?(user)
    !locked && owned_by?(user) || user&.super_user?
  end
end
