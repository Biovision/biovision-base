# frozen_string_literal: true

# Add link to SimpleImage from model
module HasSimpleImage
  extend ActiveSupport::Concern

  included do
    belongs_to :simple_image, optional: true, counter_cache: :object_count
  end

  # @return [SimpleImage]
  def image
    simple_image
  end
end
