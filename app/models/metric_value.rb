class MetricValue < ApplicationRecord
  belongs_to :metric

  validates_presence_of :time, :quantity

  scope :recent, -> { order('id desc') }
  scope :since, -> (time) { where('time >= ?', time) }
  scope :ordered_by_time, -> { order('time asc') }

  # @param [Integer] resolution hour count per chunk
  def time_for_graph(resolution = 4)
    rounded = time - time.sec - time.min * 60 - (time.hour % resolution * 3600)
    rounded + resolution.hours
  end
end
