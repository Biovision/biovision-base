# frozen_string_literal: true

# Tag for simple image
#
# Attributes:
#   created_at [DateTime]
#   name [String]
#   simple_images_count [Integer]
#   updated_at [DateTime]
class SimpleImageTag < ApplicationRecord
  include Checkable

  NAME_LIMIT = 100

  has_many :simple_image_tag_images, dependent: :delete_all

  before_validation :normalize_name
  validates_uniqueness_of :name, case_sensitive: false

  scope :list_for_administration, -> { order('name asc') }

  def self.entity_parameters
    %i[name]
  end

  private

  def normalize_name
    self.name = name.to_s[0..NAME_LIMIT]
  end
end
