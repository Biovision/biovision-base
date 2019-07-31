# frozen_string_literal: true

# Metric
# 
# Attributes:
#   biovision_component_id [BiovisionComponent], optional
#   created_at [DateTime]
#   default_period [integer]
#   incremental [boolean]
#   name [string]
#   previous_value [integer]
#   start_with_zero [boolean]
#   show_on_dashboard [boolean]
#   updated_at [DateTime]
#   value [integer]
class Metric < ApplicationRecord
  include RequiredUniqueName
  include Toggleable

  NAME_LIMIT = 255
  PERIOD_RANGE = (1..365).freeze

  METRIC_HTTP_400 = 'errors.http.bad_request.hit'
  METRIC_HTTP_401 = 'errors.http.unauthorized.hit'
  METRIC_HTTP_403 = 'errors.http.forbidden.hit'
  METRIC_HTTP_404 = 'errors.http.not_found.hit'
  METRIC_HTTP_422 = 'errors.http.unprocessable_entity.hit'
  METRIC_HTTP_500 = 'errors.http.internal_server_error.hit'
  METRIC_HTTP_503 = 'errors.http.service_unavailable.hit'

  toggleable :start_with_zero, :show_on_dashboard

  belongs_to :biovision_component, optional: true
  has_many :metric_values, dependent: :destroy

  before_validation :normalize_period
  validates_length_of :name, maximum: NAME_LIMIT

  scope :list_for_administration, -> { ordered_by_name }

  def self.page_for_administration
    order('name asc')
  end

  def self.entity_parameters
    %i[incremental start_with_zero show_on_dashboard default_period description]
  end

  # @param [String] name
  # @param [Integer] quantity
  def self.register(name, quantity = 1)
    instance = Metric.find_by(name: name)
    if instance.nil?
      instance = create(name: name, incremental: !name.end_with?('.hit'))
    end

    instance << quantity
  end

  def quantity
    metric_values.sum(:quantity)
  end

  # @param [Integer] input
  def <<(input)
    metric_values.create(time: Time.now, quantity: input)

    update(value: incremental? ? quantity : input, previous_value: value)
  end

  # @param [Integer] period
  def values(period = 7)
    current_value = 0
    metric_values.since(period.days.ago).ordered_by_time.map do |v|
      current_value = incremental? ? current_value + v.quantity : v.quantity
      [v.time.strftime('%d.%m.%Y %H:%M'), current_value]
    end.to_h
  end

  # @param [Integer] period
  # @param [Integer] resolution
  def graph_data(period = default_period, resolution = 4)
    result        = Hash.new(0)
    current_value = 0
    metric_values.since(period.days.ago).ordered_by_time.each do |v|
      key           = v.time_for_graph(resolution).strftime('%d.%m.%Y %H:%M')
      current_value = incremental? ? current_value + v.quantity : v.quantity
      if result.key?(key)
        result[key] = current_value
      else
        result[key] += current_value
      end
    end
    result
  end

  private

  def normalize_period
    self.default_period = PERIOD_RANGE.first if default_period < PERIOD_RANGE.first
    self.default_period = PERIOD_RANGE.last if default_period > PERIOD_RANGE.last
  end
end
