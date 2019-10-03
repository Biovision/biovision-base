# frozen_string_literal: true

# Simple image
# 
# Attributes:
#   agent_id [Agent], optional
#   biovision_component_id [BiovisionComponent]
#   caption [string], optional
#   created_at [DateTime]
#   data [jsonb]
#   image [SimpleImageUploader]
#   image_alt_text [string], optional
#   ip [inet], optional
#   source_link [string], optional
#   source_name [string], optional
#   updated_at [DateTime]
#   user_id [User], optional
#   uuid [uuid]
class SimpleImage < ApplicationRecord
  include Checkable
  include HasOwner

  META_LIMIT = 255

  mount_uploader :image, SimpleImageUploader

  belongs_to :agent, optional: true
  belongs_to :biovision_component
  belongs_to :user, optional: true
  has_many :simple_image_tag_images, dependent: :destroy
  has_many :simple_image_tags, through: :simple_image_tag_images

  after_initialize { self.uuid = SecureRandom.uuid if uuid.nil? }

  validates_length_of :caption, maximum: META_LIMIT
  validates_length_of :image_alt_text, maximum: META_LIMIT
  validates_length_of :source_link, maximum: META_LIMIT
  validates_length_of :source_name, maximum: META_LIMIT

  scope :list_for_administration, -> { order('image asc') }

  def self.entity_parameters
    %i[caption image image_alt_text source_link source_name]
  end
end
