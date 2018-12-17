# frozen_string_literal: true

# Biovision component
#
# Attributes:
#   - created_at [DateTime]
#   - settings [JSON]
#   - slug [String]
#   - updated_at [DateTime]
class BiovisionComponent < ApplicationRecord
  include RequiredUniqueSlug

  has_many :biovision_parameters, dependent: :delete_all

  # Find component by slug
  #
  # @param [String] slug
  def self.[](slug)
    find_by(slug: slug)
  end

  # @param [String] slug
  def receive(slug)
    biovision_parameters.find_by(slug: slug)&.value
  end

  # @param [String] slug
  # @param [String] default
  def receive!(slug, default = '')
    biovision_parameters.find_by(slug: slug)&.value || default
  end

  # @param [String] slug
  # @param [String] value
  def []=(slug, value)
    parameter = biovision_parameters.find_by(slug: slug)
    if parameter.nil?
      biovision_parameters.create!(slug: slug, value: value.to_s)
    else
      parameter.update!(value: value.to_s)
    end
  end
end
