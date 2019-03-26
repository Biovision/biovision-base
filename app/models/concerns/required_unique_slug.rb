# frozen_string_literal: true

# Mixin for adding required unique slug constrain
module RequiredUniqueSlug
  extend ActiveSupport::Concern

  included do
    before_validation { self.slug = slug.strip unless slug.nil? }
    validates :slug, uniqueness: { case_sensitive: false }, presence: true

    scope :ordered_by_slug, -> { order('slug asc') }
    scope :with_slug_like, ->(v) { where('slug ilike ?', "%#{v}%") unless v.blank? }
    scope :with_slug, ->(v) { where('lower(slug) = lower(?)', v) unless v.blank? }
  end
end
