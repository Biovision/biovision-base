# frozen_string_literal: true

# Model has nested priority field
#
# Adds sorting items by priority with siblings
# @author Maxim Khan-Magomedov <maxim.km@gmail.com>
module NestedPriority
  extend ActiveSupport::Concern

  included do
    after_initialize :set_next_priority
    before_validation :normalize_priority

    scope :ordered_by_priority, -> { order('priority asc, id asc') }

    def self.priority_range
      (1..32_767)
    end

    # Change this method in models to get siblings
    #
    # @param [ApplicationRecord] _entity
    def self.siblings(_entity)
      all
    end
  end

  # @param [Integer] delta
  def change_priority(delta)
    swap_priority_with_adjacent(priority + delta)

    siblings = self.class.siblings(self)
    siblings.ordered_by_priority.map { |e| [e.id, e.priority] }.to_h
  end

  protected

  # @param [Integer] new_priority
  def swap_priority_with_adjacent(new_priority)
    adjacent = self.class.siblings(self).find_by(priority: new_priority)
    if adjacent.is_a?(self.class) && (adjacent.id != id)
      adjacent.update!(priority: priority)
    end
    update(priority: new_priority)
  end

  def set_next_priority
    return unless id.nil? && priority == 1

    self.priority = self.class.siblings(self).maximum(:priority).to_i + 1
  end

  def normalize_priority
    range = self.class.priority_range
    self.priority = range.first if priority < range.first
    self.priority = range.last if priority > range.last
  end
end
