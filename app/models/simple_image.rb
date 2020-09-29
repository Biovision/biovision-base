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
#   object_count [Integer]
#   source_link [string], optional
#   source_name [string], optional
#   updated_at [DateTime]
#   user_id [User], optional
#   uuid [uuid]
class SimpleImage < ApplicationRecord
  include Checkable
  include HasOwner
  include HasUuid

  META_LIMIT = 255

  mount_uploader :image, SimpleImageUploader

  belongs_to :agent, optional: true
  belongs_to :biovision_component
  belongs_to :user, optional: true
  has_many :simple_image_tag_images, dependent: :destroy
  has_many :simple_image_tags, through: :simple_image_tag_images

  validates_presence_of :image
  validates_length_of :caption, maximum: META_LIMIT
  validates_length_of :image_alt_text, maximum: META_LIMIT
  validates_length_of :source_link, maximum: META_LIMIT
  validates_length_of :source_name, maximum: META_LIMIT

  scope :in_component, ->(v) { where(biovision_component: v) }
  scope :list_for_administration, -> { order('image asc') }

  def self.entity_parameters
    %i[caption image image_alt_text source_link source_name]
  end

  def name
    File.basename(image.path)
  end

  def file_size
    File.size(image.path)
  end

  def image_slug
    "#{uuid[0..2]}/#{uuid[3..5]}/#{uuid}"
  end
end
