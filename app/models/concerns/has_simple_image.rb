# frozen_string_literal: true

# Add link to SimpleImage from model
module HasSimpleImage
  extend ActiveSupport::Concern

  included do
    belongs_to :simple_image, optional: true, counter_cache: :object_count

    scope :joined_image, -> { left_joins(:simple_image) }
    scope :included_image, -> { includes(:simple_image) }
  end

  # @return [SimpleImageUploader]
  def image
    simple_image&.image
  end

  def remove_image!
    self.simple_image_id = nil
  end
end
