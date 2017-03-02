module RequiredUniqueSlug
  extend ActiveSupport::Concern

  included do
    before_validation { self.slug = slug.strip unless slug.nil? }
    validates_presence_of :slug
    validates_uniqueness_of :slug

    scope :ordered_by_slug, -> { order('slug asc') }
    scope :with_slug_like, -> (slug) { where('slug ilike ?', "%#{slug}%") unless slug.blank? }
    scope :with_slug, -> (slug) { where('slug ilike ?', slug) unless slug.blank? }
  end
end
