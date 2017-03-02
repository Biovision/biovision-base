class Browser < ApplicationRecord
  include Toggleable
  include RequiredUniqueName

  PER_PAGE = 20

  toggleable :mobile, :bot, :active

  has_many :agents, dependent: :nullify

  # @param [Integer] page
  def self.page_for_administration(page = 1)
    ordered_by_name.page(page).per(PER_PAGE)
  end

  def self.entity_parameters
    %i(name mobile bot active)
  end
end
