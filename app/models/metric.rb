class Metric < ApplicationRecord
  include RequiredUniqueName

  METRIC_HTTP_401 = 'errors.http.unauthorized.hit'
  METRIC_HTTP_404 = 'errors.http.not_found.hit'

  has_many :metric_values, dependent: :destroy

  def self.page_for_administration
    order('name asc')
  end

  def self.entity_parameters
    %i(incremental start_with_zero show_on_dashboard default_period description)
  end

  # @param [String] name
  # @param [Integer] quantity
  def self.register(name, quantity = 1)
    instance = Metric.find_by(name: name) || create(name: name, incremental: !(name =~ /\.hit\z/).nil?)
    instance.metric_values.create(time: Time.now, quantity: quantity)
    value = instance.incremental? ? instance.metric_values.sum(:quantity) : quantity

    instance.update(value: value, previous_value: instance.value)
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
end
