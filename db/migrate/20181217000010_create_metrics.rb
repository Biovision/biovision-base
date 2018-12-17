# frozen_string_literal: true

# Tables for metrics
class CreateMetrics < ActiveRecord::Migration[5.1]
  def up
    create_metrics unless Metric.table_exists?
    create_metric_values unless MetricValue.table_exists?
  end

  def down
    drop_table :metric_values if MetricValue.table_exists?
    drop_table :metrics if Metric.table_exists?
  end

  private

  def create_metrics
    create_table :metrics, comment: 'Metric for component' do |t|
      t.references :biovision_component, foreign_key: { on_update: :cascade, on_delete: :cascade }
      t.timestamps
      t.boolean :incremental, default: false, null: false
      t.boolean :start_with_zero, default: false, null: false
      t.boolean :show_on_dashboard, default: true, null: false
      t.integer :default_period, limit: 2, default: 7, null: false
      t.integer :value, default: 0, null: false
      t.integer :previous_value, default: 0, null: false
      t.string :name, null: false
    end
  end

  def create_metric_values
    create_table :metric_values, comment: 'Single metric value' do |t|
      t.references :metric, null: false, foreign_key: { on_update: :cascade, on_delete: :cascade }
      t.timestamp :time, null: false
      t.integer :quantity, null: false, default: 1
    end

    execute "create index metric_values_day_idx on metric_values using btree (date_trunc('day', time));"
  end
end
