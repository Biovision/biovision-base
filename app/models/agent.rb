class Agent < ApplicationRecord
  include Toggleable
  include RequiredUniqueName

  PER_PAGE   = 20
  NAME_LIMIT = 255

  toggleable :mobile, :bot, :active

  belongs_to :browser, optional: true, counter_cache: true

  validates_length_of :name, maximum: NAME_LIMIT

  scope :bots, ->(flag) { where(bot: flag.to_i > 0) unless flag.blank? }
  scope :mobile, ->(flag) { where(mobile: flag.to_i > 0) unless flag.blank? }
  scope :active, ->(flag) { where(active: flag.to_i > 0) unless flag.blank? }
  scope :filtered, ->(f) { with_name_like(f[:name]).bots(f[:bots]).mobile(f[:mobile]).active(f[:active]) }

  # @param [Integer] page
  # @param [Hash] filter
  def self.page_for_administration(page = 1, filter = {})
    filtered(filter).ordered_by_name.page(page).per(PER_PAGE)
  end

  def self.entity_parameters
    %i(browser_id name mobile bot active)
  end

  # Get instance of Agent for given string
  #
  # Trims agent name upto 255 characters
  #
  # @param [String] name
  # @return [Agent]
  def self.named(name)
    find_or_create_by(name: name[0..254])
  end
end
