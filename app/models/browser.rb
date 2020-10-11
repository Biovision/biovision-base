class Browser < ApplicationRecord
  include Toggleable
  include RequiredUniqueName

  PER_PAGE   = 20
  NAME_LIMIT = 250

  toggleable :mobile, :bot, :active

  has_many :agents, dependent: :nullify

  validates_length_of :name, maximum: NAME_LIMIT

  # @param [Integer] page
  def self.page_for_administration(page = 1)
    ordered_by_name.page(page).per(PER_PAGE)
  end

  def self.entity_parameters
    %i[name mobile bot active]
  end

  def text_for_link
    name
  end
end
