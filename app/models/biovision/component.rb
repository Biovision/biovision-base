# frozen_string_literal: true

# Biovision component
#
# Fields:
#   - settings [Json]
#   - slug [String]
class Biovision::Component < ApplicationRecord
  include RequiredUniqueSlug

  has_many :biovision_parameters, class_name: 'Biovision::Parameter'

  validates_presence_of :settings

  # @param [String] slug
  def self.[](slug)
    self.find_by(slug: slug)
  end

  # @param [String] slug
  def [](slug)
    biovision_parameters.find_by(slug: slug)&.value
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
