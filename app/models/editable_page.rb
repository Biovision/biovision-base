class EditablePage < ApplicationRecord
  include RequiredUniqueName
  include RequiredUniqueSlug

  NAME_LIMIT = 100
  SLUG_LIMIT = 100
  META_LIMIT = 250
  BODY_LIMIT = 65535

  mount_uploader :image, EditablePageImageUploader

  validates_length_of :name, maximum: NAME_LIMIT
  validates_length_of :slug, maximum: SLUG_LIMIT
  validates_length_of :title, maximum: META_LIMIT
  validates_length_of :keywords, maximum: META_LIMIT
  validates_length_of :description, maximum: META_LIMIT
  # validates_length_of :body, maximum: BODY_LIMIT

  def self.page_for_administration
    ordered_by_name
  end

  def self.entity_parameters
    %i(image name title keywords description body)
  end

  def self.creation_parameters
    entity_parameters + %i(slug)
  end
end
