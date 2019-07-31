# frozen_string_literal: true

# Metric value
#
# Attributes:
#   metric_id [Metric]
#   time [DateTime]
#   quantity [Integer]
class MetricValue < ApplicationRecord
  belongs_to :metric

  validates_presence_of :time, :quantity

  scope :recent, -> { order('id desc') }
  scope :since, ->(time) { where('time >= ?', time) }
  scope :ordered_by_time, -> { order('time asc') }

  # @param [Integer] hours hour count per chunk
  def time_for_graph(hours = 4)
    time - time.sec - time.min * 60 - (time.hour % hours * 3600) + hours.hours
  end
end
