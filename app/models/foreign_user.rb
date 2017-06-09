class ForeignUser < ApplicationRecord
  PER_PAGE = 20

  belongs_to :agent, optional: true
  belongs_to :foreign_site, counter_cache: true
  belongs_to :user

  before_validation :trim_fields
  validates_uniqueness_of :slug, scope: [:foreign_site_id]

  scope :ordered_by_slug, -> { order('slug asc') }

  # @param [Integer] page
  def self.page_for_administration(page = 1)
    ordered_by_slug.page(page).per(PER_PAGE)
  end

  private

  def trim_fields
    self.slug  = slug[0..255] unless slug.nil?
    self.name  = name[0..255] unless name.nil?
    self.email = email[0..255] unless email.nil?
    self.data  = data[0..65535] unless data.nil?
  end
end
