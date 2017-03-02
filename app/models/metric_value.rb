class MetricValue < ApplicationRecord
  belongs_to :metric

  validates_presence_of :time, :quantity

  scope :recent, -> { order('id desc') }
  scope :since, -> (time) { where('time >= ?', time) }
  scope :ordered_by_time, -> { order('time asc') }
end
