module RequiredUniqueSlug
  extend ActiveSupport::Concern

  included do
    before_validation { self.slug = slug.strip unless slug.nil? }
    validates :slug, uniqueness: { case_sensitive: false }, presence: true

    scope :ordered_by_slug, -> { order('slug asc') }
    scope :with_slug_like, ->(slug) { where('slug ilike ?', "%#{slug}%") unless slug.blank? }
    scope :with_slug, ->(slug) { where('lower(slug) = lower(?)', slug) unless slug.blank? }
  end
end
