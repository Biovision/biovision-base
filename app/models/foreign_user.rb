class ForeignUser < ApplicationRecord
  PER_PAGE = 20

  belongs_to :agent, optional: true
  belongs_to :foreign_site, counter_cache: true
  belongs_to :user

  validates_uniqueness_of :slug, scope: [:foreign_site_id]

  scope :ordered_by_slug, -> { order('slug asc') }

  # @param [Integer] page
  def self.page_for_administration(page = 1)
    ordered_by_slug.page(page).per(PER_PAGE)
  end
end
