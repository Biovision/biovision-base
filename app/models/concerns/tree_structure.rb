# frozen_string_literal: true

# Model has parent and children
module TreeStructure
  extend ActiveSupport::Concern

  included do
    belongs_to :parent, class_name: self.class.to_s, optional: true
    has_many :child_items, class_name: self.class.to_s, foreign_key: :parent_id, dependent: :destroy

    before_save { children_cache.uniq! }
    after_create :cache_parents!
    after_save { parent&.cache_children! }

    def depth
      parent_ids.count
    end

    def parent_ids
      parents_cache.split(',').compact
    end

    # @return [Array<Integer>]
    def branch_ids
      parents_cache.split(',').map(&:to_i).reject { |i| i < 1 }.uniq + [id]
    end

    # @return [Array<Integer>]
    def subbranch_ids
      [id] + children_cache
    end

    def parents
      return [] if parents_cache.blank?

      self.class.where(id: parent_ids).order('id asc')
    end

    def cache_parents!
      return if parent.nil?

      self.parents_cache = "#{parent.parents_cache},#{parent_id}".gsub(/\A,/, '')
      save!
    end

    # @param [Array] new_cache
    def cache_children!(new_cache = [])
      if new_cache.blank?
        new_cache = child_items.order('id asc').pluck(:id, :children_cache)
      end

      self.children_cache += new_cache.flatten
      self.children_cache.uniq!

      save!
      parent&.cache_children!([id] + children_cache)
    end
  end
end