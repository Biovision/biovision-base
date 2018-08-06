class ForeignUser < ApplicationRecord
  include HasOwner

  belongs_to :agent, optional: true
  belongs_to :foreign_site, counter_cache: true
  belongs_to :user

  before_validation :trim_fields
  validates_uniqueness_of :slug, scope: [:foreign_site_id]

  scope :ordered_by_slug, -> { order('slug asc') }
  scope :list_for_administration, -> { ordered_by_slug }

  # @param [Integer] page
  def self.page_for_administration(page = 1)
    list_for_administration.page(page)
  end

  def long_slug
    "#{foreign_site.slug}-#{slug}"
  end

  private

  def trim_fields
    self.slug  = slug[0..255] unless slug.nil?
    self.name  = name[0..255] unless name.nil?
    self.email = email[0..255] unless email.nil?
    self.data  = data[0..65535] unless data.nil?
  end
end
