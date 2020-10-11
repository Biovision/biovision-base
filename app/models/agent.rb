# frozen_string_literal: true

# User agent
#
# Attributes:
#   active [boolean]
#   bot [boolean]
#   browser_id [Browser], optional
#   created_at [datetime]
#   deleted [boolean]
#   locked [boolean]
#   mobile [boolean]
#   name [string]
#   updated_at [datetime]
class Agent < ApplicationRecord
  include Toggleable
  include RequiredUniqueName

  NAME_LIMIT = 255

  toggleable :mobile, :bot, :active

  belongs_to :browser, optional: true, counter_cache: true

  validates_length_of :name, maximum: NAME_LIMIT

  scope :bots, ->(flag) { where(bot: flag.to_i.positive?) unless flag.blank? }
  scope :mobile, ->(flag) { where(mobile: flag.to_i.positive?) unless flag.blank? }
  scope :active, ->(flag) { where(active: flag.to_i.positive?) unless flag.blank? }
  scope :filtered, ->(f) { with_name_like(f[:name]).bots(f[:bots]).mobile(f[:mobile]).active(f[:active]) }
  scope :list_for_administration, -> { ordered_by_name }

  # @param [Integer] page
  # @param [Hash] filter
  def self.page_for_administration(page = 1, filter = {})
    filtered(filter).list_for_administration.page(page)
  end

  def self.entity_parameters
    %i[active bot browser_id mobile name]
  end

  # @param [String] name
  def self.[](name)
    return if name.blank?

    range_end = NAME_LIMIT - 1
    find_or_create_by(name: name[0..range_end])
  end

  # Get instance of Agent for given string
  #
  # Trims agent name upto 255 characters
  #
  # @param [String] name
  # @return [Agent]
  def self.named(name)
    Agent[name]
  end

  def text_for_link
    name
  end
end
