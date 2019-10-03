# frozen_string_literal: true

# Link between simpla image ang simple image tag
#
# Attributes:
#   simple_image_id [SimpleImage]
#   simple_image_tag_id [SimpleImageTag]
class SimpleImageTagImage < ApplicationRecord
  belongs_to :simple_image
  belongs_to :simple_image_tag, counter_cache: :simple_images_count

  validates_uniqueness_of :simple_image_tag_id, scope: :simple_image_id
end
