module RequiredUniqueName
  extend ActiveSupport::Concern

  included do
    before_validation { self.name = name.strip unless name.nil? }
    validates_presence_of :name
    validates_uniqueness_of :name

    scope :ordered_by_name, -> { order('name asc') }
    scope :with_name_like, ->(name) { where('name ilike ?', "%#{name}%") unless name.blank? }
    scope :with_name, ->(name) { where('lower(name) = lower(?)', name) unless name.blank? }
  end
end
