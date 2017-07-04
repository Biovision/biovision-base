class Region < ApplicationRecord
  include Toggleable

  SLUG_PATTERN = /\A[a-z0-9](?:[a-z0-9\-]{0,61}[a-z0-9])?\z/
  PER_PAGE     = 20
  NAME_LIMIT   = 70
  SLUG_LIMIT   = 63

  toggleable :visible

  belongs_to :parent, class_name: Region.to_s, optional: true, touch: true
  has_many :child_regions, class_name: Region.to_s, foreign_key: :parent_id
  has_many :news, dependent: :nullify
  has_many :users, dependent: :nullify
  has_many :albums, dependent: :nullify

  mount_uploader :image, RegionImageUploader
  mount_uploader :header_image, HeaderImageUploader

  before_validation { self.slug = slug.to_s.downcase.strip }
  before_save { self.children_cache.uniq! }
  before_save :generate_long_slug

  validates_presence_of :name, :slug
  validates_uniqueness_of :name, :slug, scope: [:parent_id]
  validates_length_of :name, maximum: NAME_LIMIT
  validates_length_of :slug, maximum: SLUG_LIMIT
  validates_format_of :slug, with: SLUG_PATTERN

  scope :ordered_by_slug, -> { order('slug asc') }
  scope :ordered_by_name, -> { order('name asc') }
  scope :visible, -> { where(visible: true) }
  scope :for_tree, -> (parent_id = nil) { where(parent_id: parent_id).ordered_by_name }

  # @param [Integer] page
  def self.page_for_administration(page = 1)
    ordered_by_name.page(page).per(PER_PAGE)
  end

  def self.entity_parameters
    %i(name short_name locative slug visible image header_image latitude longitude)
  end

  def self.creation_parameters
    entity_parameters + %i(parent_id)
  end

  # @param [User] user
  def editable_by?(user)
    administrator = UserPrivilege.user_has_privilege?(user, :administrator)
    manager       = UserPrivilege.user_has_privilege?(user, :region_manager, self)
    (administrator || manager) && !locked?
  end

  def parents
    return [] if parents_cache.blank?
    Region.where(id: parent_ids).order('id asc')
  end

  def parent_ids
    parents_cache.split(',').compact
  end

  def depth
    parent_ids.count
  end

  def long_name
    return name if parents.blank?
    "#{parents.map(&:name).join('/')}/#{name}"
  end

  def cache_parents!
    return if parent.nil?
    self.parents_cache = "#{parent.parents_cache},#{parent_id}".gsub(/\A,/, '')
    save!
  end

  def cache_children!
    child_regions.order('id asc').each do |child|
      self.children_cache += [child.id] + child.children_cache
    end
    save!
    parent.cache_children! unless parent.nil?
  end

  private

  def generate_long_slug
    if parents_cache.blank?
      self.long_slug = slug
    else
      slugs          = Region.where(id: parent_ids).order('id asc').pluck(:slug) + [slug]
      self.long_slug = slugs.join('-')
    end
  end
end
